import Foundation

struct CharactersResponse: Decodable {
    let results: [CharacterResponse]
}

struct CharacterResponse: Decodable {
    struct LocationResponse: Decodable {
        let name: String
    }

    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
    let episode: [String]
    let location: LocationResponse
}

extension CharacterResponse {
    func toModel() -> CharacterModel {
        CharacterModel(
            id: id,
            name: name,
            status: CharacterStatus(rawValue: status.lowercased()) ?? .unknown,
            species: species,
            gender: gender,
            imageURL: URL(string: image),
            episodeIDs: episode.compactMap { URL(string: $0)?.lastPathComponent }.compactMap(Int.init),
            locationName: location.name
        )
    }
}
