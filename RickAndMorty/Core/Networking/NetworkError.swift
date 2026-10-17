import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case notFound
    case server(statusCode: Int)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: "The request address is invalid."
        case .invalidResponse: "The server response was not valid."
        case .notFound: "Nothing was found."
        case .server(let code): "The server returned an error (\(code))."
        }
    }
}
