import Foundation

protocol ServiceProtocol {
    func request<T: Decodable>(type: ServiceEndPoint) async throws -> T
}

final class APIService: ServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(type: ServiceEndPoint) async throws -> T {
        guard let url = type.url else { throw NetworkError.invalidURL }

        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }

        switch http.statusCode {
        case 200..<300: return try decoder.decode(T.self, from: data)
        case 404: throw NetworkError.notFound
        default: throw NetworkError.server(statusCode: http.statusCode)
        }
    }
}
