//
//  PocketNewsController.swift
//  PocketNews
//
//  Created by Vitaliy Vaisman on 22.11.2022.
//

import SwiftUI
import Combine

final class PocketNewsController: ObservableObject {
    @Published private(set) var pocketNews: [News] = []
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    @AppStorage(AppStorageKeys.method.rawValue) var method: NytAPI.Method = .viewed {
        didSet {fetchNewsFromCacheAndNetwork()}
    }
    
    @AppStorage(AppStorageKeys.period.rawValue) var period: NytAPI.Method.Period = .day {
        didSet {fetchNewsFromCacheAndNetwork()}
    }
    
    var redactedReason: RedactionReasons { isLoading  ? .placeholder : [] }
    
    private var cachedNewsQueue = DispatchQueue(label: "cachedArticles")
    private var cancellableGetNews: AnyCancellable?
    
    private let fetcher: NytAPIFetchable
    private let cache: Cacheable
    private let decoder: JSONDecoder
    
    init(fetcher: NytAPIFetchable = NytAPI(), cache: Cacheable = Cache()) {
        
        self.fetcher = fetcher
        self.cache = cache
        
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
    }
    
    func fetchNewsFromCacheAndNetwork() {
        isLoading = true
        fetchNewsfromNetwork()
        fetchNewsFromCache()
    }
    
    func fetchNewsfromNetwork() {
        isLoading = true
        
        cancellableGetNews = getNewsFromNetworkPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] news in
                self?.pocketNews = news
                self?.saveNewsToCache(news)
                self?.isLoading = false
            })
    }
    
    private func fetchNewsFromCache() {
        isLoading = true
        
        let newsDirectoryURL = cache.directoryURL
            .appendingPathComponent(CachePath.news.rawValue)
            .appendingPathComponent(method.rawValue)
            .appendingPathComponent(period.rawValue)
        
        getNewsFromCashePublisher(from: newsDirectoryURL)
            .subscribe(on: cachedNewsQueue)
            .receive(on: DispatchQueue.main)
            .assign(to: &$pocketNews)
    }
    
    private func  getNewsFromCashePublisher(from directory: URL) -> AnyPublisher <[News], Never> {
        var cachedNews: [News] = []
        
        if let data = cache.get(from: directory),
           let decodedNews = try? decoder.decode([News].self, from: data) {
            
            cachedNews = decodedNews
        }
        return Just(cachedNews)
            .eraseToAnyPublisher()
    }
    
    private func getNewsFromNetworkPublisher() -> AnyPublisher<[News], NetworkErrors> {
        fetcher.fetch(method: method, period: period)
            .decode(type: Response.self, decoder: decoder)
            .mapError(NetworkErrors.handleError)
            .map(\.result)
            .eraseToAnyPublisher()
    }
    
    private func saveNewsToCache(_ news: [News]) {
        
        let newsDirectoryURL = cache.directoryURL
            .appendingPathComponent(CachePath.news.rawValue)
            .appendingPathComponent(method.rawValue)
            .appendingPathComponent(period.rawValue)
        
        let encoder = JSONEncoder()
        
        if !cache.fileExists(atPath: newsDirectoryURL.path) {
            cache.createDirectory(atPath: newsDirectoryURL.path)
        }
        
        let newsPathURL = newsDirectoryURL
            .appendingPathComponent(CachePath.news.rawValue)
        
        guard let data  = try? encoder.encode(news) else {return}
        cache.save(data, to: newsPathURL)
    }
}

enum AppStorageKeys: String {
    case method
    case period
}
