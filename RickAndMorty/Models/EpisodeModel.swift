import Foundation

struct EpisodeModel: Identifiable, Equatable {
    let id: Int
    let name: String
    let code: String      // e.g. "S01E01"
    let season: Int
    let airDate: String
}
