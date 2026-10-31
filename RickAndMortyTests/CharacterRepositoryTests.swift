import XCTest
@testable import RickAndMorty

final class CharacterRepositoryTests: XCTestCase {
    func testMapsResponseToModel() async throws {
        let json = """
        {"results":[{"id":1,"name":"Rick Sanchez","status":"Alive","species":"Human","gender":"Male",
        "image":"https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        "episode":["https://rickandmortyapi.com/api/episode/1","https://rickandmortyapi.com/api/episode/2","https://rickandmortyapi.com/api/episode/3"],"location":{"name":"Citadel of Ricks"}}]}
        """
        let service = StubService(result: .success(try JSONDecoder().decode(CharactersResponse.self, from: Data(json.utf8))))
        let sut = CharacterRepository(service: service)

        let characters = try await sut.characters(matching: "")

        XCTAssertEqual(characters.count, 1)
        XCTAssertEqual(characters[0].name, "Rick Sanchez")
        XCTAssertEqual(characters[0].status, .alive)
        XCTAssertEqual(characters[0].episodeCount, 3)
        XCTAssertEqual(characters[0].locationName, "Citadel of Ricks")
    }

    func testNotFoundBecomesEmptyList() async throws {
        let sut = CharacterRepository(service: StubService(result: .failure(NetworkError.notFound)))
        let characters = try await sut.characters(matching: "zzzz")
        XCTAssertTrue(characters.isEmpty)
    }

    func testEndpointEncodesQuery() {
        let url = CharactersEndpoint.characters(name: "rick & morty").url
        XCTAssertEqual(url?.absoluteString, "https://rickandmortyapi.com/api/character?name=rick%20%26%20morty")
    }
}

private struct StubService: ServiceProtocol {
    let result: Result<CharactersResponse, Error>

    func request<T: Decodable>(type: ServiceEndPoint) async throws -> T {
        guard let value = try result.get() as? T else { throw NetworkError.invalidResponse }
        return value
    }
}
