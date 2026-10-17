import XCTest
@testable import RickAndMorty

@MainActor
final class CharacterListViewModelTests: XCTestCase {
    private let rick = CharacterModel(id: 1, name: "Rick", status: .alive, species: "Human", gender: "Male",
                                 imageURL: nil, episodeCount: 5, locationName: "Earth")

    func testLoadsCharacters() async {
        let sut = CharacterListViewModel(repository: MockRepository(result: .success([rick])))
        try? await sut.loadCharacters(matching: "")
        XCTAssertEqual(sut.state, .loaded([rick]))
    }

    func testEmptySearchShowsEmptyState() async {
        let sut = CharacterListViewModel(repository: MockRepository(result: .success([])))
        try? await sut.loadCharacters(matching: "nobody")
        XCTAssertEqual(sut.state, .empty)
    }

    func testFailureShowsError() async {
        let sut = CharacterListViewModel(repository: MockRepository(result: .failure(NetworkError.server(statusCode: 500))))
        try? await sut.loadCharacters(matching: "")
        XCTAssertEqual(sut.state, .failed(NetworkError.server(statusCode: 500).localizedDescription))
    }
}

final class MockRepository: CharacterRepositoryProtocol, @unchecked Sendable {
    let result: Result<[CharacterModel], Error>
    private(set) var lastName: String?
    init(result: Result<[CharacterModel], Error>) { self.result = result }

    func characters(matching name: String) async throws -> [CharacterModel] {
        lastName = name
        return try result.get()
    }
}

extension CharacterListViewModelTests {
    func testSearchTextIsTrimmedBeforeRequest() async {
        let repo = MockRepository(result: .success([]))
        let sut = CharacterListViewModel(repository: repo)
        try? await sut.loadCharacters(matching: "  rick \n")
        XCTAssertEqual(repo.lastName, "rick")
    }
}

extension CharacterListViewModelTests {
    func testCancelledTaskRethrowsAndKeepsState() async {
        for error in [CancellationError() as Error, URLError(.cancelled)] {
            let sut = CharacterListViewModel(repository: MockRepository(result: .failure(error)))
            let task = Task { try await sut.loadCharacters(matching: "") }
            task.cancel()
            let result = await task.result
            XCTAssertThrowsError(try result.get())
            XCTAssertEqual(sut.state, .loading)
        }
    }
}
