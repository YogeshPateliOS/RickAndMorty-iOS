import XCTest
@testable import RickAndMorty

final class EpisodeTests: XCTestCase {
    func testCharacterResponseExtractsEpisodeIDsFromURLs() throws {
        let json = """
        {"id":1,"name":"Rick","status":"Alive","species":"Human","gender":"Male","image":"",
        "episode":["https://rickandmortyapi.com/api/episode/1","https://rickandmortyapi.com/api/episode/28"],
        "location":{"name":"Earth"}}
        """
        let model = try JSONDecoder().decode(CharacterResponse.self, from: Data(json.utf8)).toModel()
        XCTAssertEqual(model.episodeIDs, [1, 28])
        XCTAssertEqual(model.episodeCount, 2)
    }

    func testEpisodeResponseMapsSeasonFromCode() throws {
        let json = #"{"id":12,"name":"Pilot","air_date":"December 2, 2013","episode":"S02E01"}"#
        let model = try JSONDecoder().decode(EpisodeResponse.self, from: Data(json.utf8)).toModel()
        XCTAssertEqual(model.season, 2)
        XCTAssertEqual(model.airDate, "December 2, 2013")
    }

    func testEndpointUsesBracketsForSingleId() {
        XCTAssertEqual(EpisodesEndpoint.episodes(ids: [7]).url?.absoluteString,
                       "https://rickandmortyapi.com/api/episode/%5B7%5D")
    }
}
