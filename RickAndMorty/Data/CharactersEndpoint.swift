import Foundation

// https://rickandmortyapi.com/api/character/?name=rick
enum CharactersEndpoint {
    case characters(name: String)
}

extension CharactersEndpoint: ServiceEndPoint {
    var baseUrl: String { "https://rickandmortyapi.com/api" }

    var path: String {
        switch self {
        case .characters: "/character"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .characters(let name):
            name.isEmpty ? [] : [URLQueryItem(name: "name", value: name)]
        }
    }
}
