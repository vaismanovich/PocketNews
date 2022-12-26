//
//  NetworkErrors.swift
//  PocketNews
//
//  Created by Vitaliy Vaisman on 23/11/2022.
//

import Foundation

enum NetworkErrors: Error, Equatable {
    case wrongURL
    case unknown
    case message(reason: String)
    case parseError
    case timeOut
    case noInternet
    
    static func processResponse(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkErrors.unknown
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 401, 404:
            throw Self.message(reason: "Service unavailable")
        case 429:
            throw Self.message(reason: "Too many requests")
        default:
            throw Self.unknown
        }
    }
    
    static func handleError(_ failureError: Error) -> NetworkErrors {
        switch failureError {
        case is Swift.DecodingError:
            return .parseError
        case let error as URLError where error.code == URLError.Code.notConnectedToInternet:
            return .noInternet
        case let error as URLError where error.code == URLError.Code.timedOut:
            return .timeOut
        case let error as NetworkErrors:
            return error
            
        default:
            return .unknown
        }
    }
}

extension NetworkErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongURL, .parseError:
            return "Service unavailable"
        case .unknown:
            return "Something wemt wrong"
        case .message(reason: let reason):
            return reason
        case .noInternet:
            return "No internet connection"
        case .timeOut:
            return "Timeout internet connection"
        }
    }
}
