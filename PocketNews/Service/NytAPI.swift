//
//  NytAPI.swift
//  PocketNews
//
//  Created by Мария Шувалова on 23.11.2022.
//

import Foundation
import Combine
import SwiftUI

protocol NytAPIFetchable {
    func fetch() -> AnyPublisher<Data, Error>
}

final class NytAPI: NytAPIFetchable {
    private let apiKey = "" //will set here API key in future
    private let scheme = "https"
    private let host = "api.nytimes.com"
    
    private let apiExtension = "json"
    private let urlRequestTimeoutInterval: TimeInterval = 5
    private let networkFetchingQueue = DispatchQueue(label: "networkFetching")
    
   
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
    var
}
