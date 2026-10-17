import Foundation

protocol CharacterRepositoryProtocol {
    func characters(matching name: String) async throws -> [CharacterModel]
}

final class CharacterRepository: CharacterRepositoryProtocol {
    private let service: ServiceProtocol

    init(service: ServiceProtocol) {
        self.service = service
    }

    func characters(matching name: String) async throws -> [CharacterModel] {
        do {
            let response: CharactersResponse = try await service.request(type: CharactersEndpoint.characters(name: name))
            return response.results.map { $0.toModel() }
        } catch NetworkError.notFound {
            // the API returns 404 when a search has no matches
            return []
        }
    }
}
