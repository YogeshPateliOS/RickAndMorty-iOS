import Foundation

struct CharacterModel: Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let gender: String
    let imageURL: URL?
    let episodeCount: Int
    let locationName: String
}

enum CharacterStatus: String {
    case alive, dead, unknown

    var title: String { rawValue.capitalized }
}

#if DEBUG
extension CharacterModel {
    static let sample = CharacterModel(
        id: 1, name: "Rick Sanchez", status: .alive, species: "Human", gender: "Male",
        imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"),
        episodeCount: 51, locationName: "Citadel of Ricks"
    )
}
#endif
