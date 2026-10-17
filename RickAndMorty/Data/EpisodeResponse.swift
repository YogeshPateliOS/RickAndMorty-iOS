import Foundation

struct EpisodeResponse: Decodable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String

    enum CodingKeys: String, CodingKey {
        case id, name, episode
        case airDate = "air_date"
    }
}

extension EpisodeResponse {
    func toModel() -> EpisodeModel {
        EpisodeModel(
            id: id,
            name: name,
            code: episode,
            season: Int(episode.dropFirst().prefix(2)) ?? 0,
            airDate: airDate
        )
    }
}
