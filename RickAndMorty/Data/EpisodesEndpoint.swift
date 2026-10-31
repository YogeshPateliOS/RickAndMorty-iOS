import Foundation

// https://rickandmortyapi.com/api/episode/[1,2,3]
enum EpisodesEndpoint {
    case episodes(ids: [Int])
}

extension EpisodesEndpoint: ServiceEndPoint {
    var baseUrl: String { "https://rickandmortyapi.com/api" }

    var path: String {
        switch self {
        case .episodes(let ids):
            // brackets make the API return an array even for a single id
            "/episode/[\(ids.map(String.init).joined(separator: ","))]"
        }
    }
}
