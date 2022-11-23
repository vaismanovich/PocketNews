

import Foundation

extension URL {
    init?(scheme: String, host: String, path: String, parameters: [String: String]? = nil) {
        var components = URLComponents()
        
        components.scheme = scheme
        components.host = host
        components.path = path
        
        if let parameters = parameters {
            components.setQueryItems(with: parameters)
        }
        if let urlString = components.url?.absoluteString {
            self.init(string: urlString)
        } else {
            return nil
        }
    }
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value)}
    }
}
