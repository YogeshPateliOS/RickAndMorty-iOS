import Foundation

protocol ServiceEndPoint {
    var baseUrl: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var url: URL? { get }
}

extension ServiceEndPoint {
    var queryItems: [URLQueryItem] { [] }

    var url: URL? {
        var components = URLComponents(string: baseUrl + path)
        if !queryItems.isEmpty { components?.queryItems = queryItems }
        return components?.url
    }
}
