import Foundation

struct CharacterModel: Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let gender: String
    let imageURL: URL?
    let episodeIDs: [Int]
    let locationName: String

    var episodeCount: Int { episodeIDs.count }
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
        episodeIDs: Array(1...51), locationName: "Citadel of Ricks"
    )
}
#endif
