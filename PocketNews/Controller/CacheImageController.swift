//
//  CacheImageController.swift
//  PocketNews
//
//  Created by Vitaliy Vaisman on 13.12.2022.
//

import SwiftUI
import Combine

protocol ImageFetchable {
    func fetch(from url: URL) -> AnyPublisher<Data, URLError>
}

final class ImageFetcher: ImageFetchable  {
    func fetch(from url: URL) -> AnyPublisher<Data, URLError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}

final class CacheImageController: ObservableObject {
    @Published var uiImage: UIImage?
    
    private let url: URL?
    private(set) var state: State
    private var cancellable: AnyCancellable?
    private let imageFetchingQueue = DispatchQueue(label: "ImageFetching")
    
    private let fetcher : ImageFetchable
    private let cache: Cacheable
    private let imageDirectoryURL: URL
    
    init(url: URL?, fetcher: ImageFetchable = ImageFetcher(), cache: Cacheable = Cache()) {
        self.state = .none
        self.fetcher = fetcher
        self.url = url
        self.cache = cache
        
        self.imageDirectoryURL = cache.directoryURL.appendingPathComponent(CachePath.images.rawValue)
    }
    
    func fetch() {
        guard state == .none, let url = url else { return }
        
        let imageURL = imageDirectoryURL
            .appendingPathComponent(url.deletingPathExtension().lastPathComponent)
        
        if let cachedData = cache.get(from: imageURL),
           let cachedUIImage = UIImage(data: cachedData){
            
            self.uiImage = cachedUIImage
            state = .success
            return
        }
        
        cancellable = fetcher.fetch(from: url)
            .subscribe(on: imageFetchingQueue)
            .map {UIImage(data: $0) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .handleEvents(
                receiveSubscription: { [weak self] _ in
                    self?.state = .loading
                },
                receiveOutput: { [weak self] image in
                    guard let image = image else { return }
                    try? self?.saveImageToCache(image, to: imageURL)
                })
            .sink(receiveCompletion: { [weak self] in
                if case .failure = $0 {
                    self?.state = .failed
                }
            }, receiveValue: { [weak self] image in
                self?.uiImage = image
                self?.state = .success
            })
    }
    
    private func saveImageToCache(_ image: UIImage, to url: URL) throws {
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        if !cache.fileExists(atPath: imageDirectoryURL.path) {
            cache.createDirectory(atPath: imageDirectoryURL.path)
        }
        self.cache.save(data, to: url)
    }
}

extension CacheImageController {
    enum State {
        case failed, none
        case loading
        case success
    }
}
