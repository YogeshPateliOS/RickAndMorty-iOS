import SwiftUI

@main
struct RickAndMortyApp: App {
    private let characterRepository: CharacterRepositoryProtocol
    private let episodeRepository: EpisodeRepositoryProtocol

    init() {
        let service = APIService()
        characterRepository = CharacterRepository(service: service)
        episodeRepository = EpisodeRepository(service: service)
    }

    var body: some Scene {
        WindowGroup {
            CharacterListView(
                viewModel: CharacterListViewModel(repository: characterRepository),
                makeDetailViewModel: { [episodeRepository] character in
                    CharacterDetailViewModel(character: character, repository: episodeRepository)
                }
            )
        }
    }
}
