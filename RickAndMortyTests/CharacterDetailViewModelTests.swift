import XCTest
@testable import RickAndMorty

@MainActor
final class CharacterDetailViewModelTests: XCTestCase {
    private let character = CharacterModel.sample

    private func episode(_ id: Int, season: Int) -> EpisodeModel {
        EpisodeModel(id: id, name: "Ep \(id)", code: "S0\(season)E0\(id)", season: season, airDate: "")
    }

    func testGroupsEpisodesBySeasonInOrder() async throws {
        let repo = StubEpisodeRepository(result: .success([episode(11, season: 2), episode(2, season: 1), episode(1, season: 1)]))
        let sut = CharacterDetailViewModel(character: character, repository: repo)

        try await sut.loadEpisodes()

        guard case .loaded(let sections) = sut.state else { return XCTFail("Expected loaded") }
        XCTAssertEqual(sections.map(\.season), [1, 2])
        XCTAssertEqual(sections[0].episodes.map(\.id), [1, 2])
    }

    func testFailureShowsError() async throws {
        let repo = StubEpisodeRepository(result: .failure(NetworkError.server(statusCode: 500)))
        let sut = CharacterDetailViewModel(character: character, repository: repo)

        try await sut.loadEpisodes()

        XCTAssertEqual(sut.state, .failed(NetworkError.server(statusCode: 500).localizedDescription))
    }

    func testCancelledTaskRethrowsAndDoesNotShowError() async {
        let repo = StubEpisodeRepository(result: .failure(URLError(.cancelled)))
        let sut = CharacterDetailViewModel(character: character, repository: repo)
        let task = Task { try await sut.loadEpisodes() }
        task.cancel()
        let result = await task.result
        XCTAssertThrowsError(try result.get())
        XCTAssertEqual(sut.state, .loading)
    }
}

private struct StubEpisodeRepository: EpisodeRepositoryProtocol {
    let result: Result<[EpisodeModel], Error>

    func episodes(ids: [Int]) async throws -> [EpisodeModel] { try result.get() }
}
