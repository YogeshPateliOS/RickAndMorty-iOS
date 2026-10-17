import Foundation
import Observation

struct SeasonSection: Identifiable, Equatable {
    let season: Int
    let episodes: [EpisodeModel]

    var id: Int { season }
}

@Observable
@MainActor
final class CharacterDetailViewModel {
    enum State: Equatable {
        case loading
        case loaded([SeasonSection])
        case failed(String)
    }

    let character: CharacterModel
    private(set) var state: State = .loading

    private let repository: EpisodeRepositoryProtocol

    init(character: CharacterModel, repository: EpisodeRepositoryProtocol) {
        self.character = character
        self.repository = repository
    }

    func loadEpisodes() async throws {
        state = .loading
        do {
            let episodes = try await repository.episodes(ids: character.episodeIDs)
            state = .loaded(Self.sections(from: episodes))
        } catch {
            try Task.checkCancellation()
            state = .failed(error.localizedDescription)
        }
    }

    private static func sections(from episodes: [EpisodeModel]) -> [SeasonSection] {
        Dictionary(grouping: episodes, by: \.season)
            .map { SeasonSection(season: $0.key, episodes: $0.value.sorted { $0.id < $1.id }) }
            .sorted { $0.season < $1.season }
    }
}
