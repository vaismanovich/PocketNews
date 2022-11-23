//
//  NytAPI.swift
//  PocketNews
//
//  Created by Vitaliy Vaisman on 23.11.2022.
//

import Foundation
import Combine

protocol NytAPIFetchable {
    func fetch(method: NytAPI.Method, period: NytAPI.Method.Period) -> AnyPublisher<Data, Error>
}

final class NytAPI: NytAPIFetchable {
    private let apiKey = "2pxffUsNNhwYPfnuQB7OnF1gKy9jQ18B" //will set here API key in future
    private let scheme = "https"
    private let host = "api.nytimes.com"
    
    private let apiExtension = "json"
    private let urlRequestTimeoutInterval: TimeInterval = 5
    private let networkFetchingQueue = DispatchQueue(label: "networkFetching")
    
    func fetch(method: Method, period: Method.Period) -> AnyPublisher<Data, Error> {
        guard let request = makeURLRequest(method: method, period: period) else {
            return Fail(error: NetworkErrors.wrongURL)
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: networkFetchingQueue)
            .tryMap(NetworkErrors.processResponse)
            .eraseToAnyPublisher()
    }
    
    private func makeURL(for method: Method, period: Method.Period) -> URL? {
        let fullPath = method.path + period.path
        
    var url = URL(scheme: scheme,
                  host: host,
                  path: fullPath,
                  parameters: ["api-key": apiKey])
        
        url?.appendPathExtension(apiExtension)
        return url
    }
    
  
    private func makeURLRequest(method: Method, period: Method.Period) -> URLRequest? {
        guard let url = makeURL(for: method, period: period) else {return nil}
        
        return URLRequest(url: url,
                            timeoutInterval: urlRequestTimeoutInterval)
    }
   
}

// MARK: - Extension

extension NytAPI {
    enum Method: String, CaseIterable, Identifiable {
        case viewed = "viewed"
        case shared = "shared"
        case emailed = "emailed"
        
        private static let basePath = "/svc/mostpopular/v2"
        
        var path: String { Self.basePath + "/" + self.rawValue}
        var id: String { self.rawValue}
    }
}

extension NytAPI.Method {
    enum Period: String, CaseIterable, Identifiable {
        case day
        case week
        case month
        
        var path: String {
            switch self {
            case .day:
                return "/1"
            case .week:
                return "/7"
            case .month:
                return "/30"
            }
        }
        
        var id: String {self.rawValue}
    }
}

extension NytAPI.Method.Period: CustomStringConvertible {
    var description: String {
        switch self {
        case .day, .week:
            return "of the " + self.rawValue
        case .month:
            return "in a " + self.rawValue
        }
    }
}
