import Foundation

protocol EpisodeRepositoryProtocol {
    func episodes(ids: [Int]) async throws -> [EpisodeModel]
}

final class EpisodeRepository: EpisodeRepositoryProtocol {
    private let service: ServiceProtocol

    init(service: ServiceProtocol) {
        self.service = service
    }

    func episodes(ids: [Int]) async throws -> [EpisodeModel] {
        guard !ids.isEmpty else { return [] }
        let response: [EpisodeResponse] = try await service.request(type: EpisodesEndpoint.episodes(ids: ids))
        return response.map { $0.toModel() }
    }
}
