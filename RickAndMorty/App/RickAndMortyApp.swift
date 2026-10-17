import SwiftUI

@main
struct RickAndMortyApp: App {
    private let repository: CharacterRepositoryProtocol = CharacterRepository(service: APIService())

    var body: some Scene {
        WindowGroup {
            CharacterListView(viewModel: CharacterListViewModel(repository: repository))
        }
    }
}
