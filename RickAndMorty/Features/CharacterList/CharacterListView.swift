import SwiftUI

struct CharacterListView: View {
    @State private var viewModel: CharacterListViewModel
    @State private var searchText = ""
    private let makeDetailViewModel: (CharacterModel) -> CharacterDetailViewModel

    init(viewModel: CharacterListViewModel, makeDetailViewModel: @escaping (CharacterModel) -> CharacterDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
        self.makeDetailViewModel = makeDetailViewModel
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Characters")
                .navigationDestination(for: CharacterModel.self) { CharacterDetailView(viewModel: makeDetailViewModel($0)) }
                .searchable(text: $searchText, prompt: "Search by name")
        }
        .task(id: searchText) {
            do {
                if !searchText.isEmpty {
                    try await Task.sleep(for: .milliseconds(400)) // debounce
                }
                try await viewModel.loadCharacters(matching: searchText)
            } catch {
                // cancelled by a newer keystroke
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading…")
        case .loaded(let characters):
            List(characters) { character in
                NavigationLink(value: character) {
                    CharacterRow(character: character)
                }
            }
            .listStyle(.plain)
        case .empty:
            ContentUnavailableView.search(text: searchText)
        case .failed(let message):
            ContentUnavailableView {
                Label("Something went wrong", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Try Again") {
                    Task { try? await viewModel.loadCharacters(matching: searchText) }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
