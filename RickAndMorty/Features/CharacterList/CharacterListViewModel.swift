import Foundation
import Observation

@Observable
@MainActor
final class CharacterListViewModel {
    enum State: Equatable {
        case loading
        case loaded([CharacterModel])
        case empty
        case failed(String)
    }

    private(set) var state: State = .loading

    private let repository: CharacterRepositoryProtocol

    init(repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }

    func loadCharacters(matching text: String) async throws {
        let name = text.trimmingCharacters(in: .whitespacesAndNewlines)
        do {
            let characters = try await repository.characters(matching: name)
            state = characters.isEmpty ? .empty : .loaded(characters)
        } catch {
            try Task.checkCancellation() // cancelled, so don't show an error
            state = .failed(error.localizedDescription)
        }
    }
}
