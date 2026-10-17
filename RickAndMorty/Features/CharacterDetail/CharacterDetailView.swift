import SwiftUI

struct CharacterDetailView: View {
    @State private var viewModel: CharacterDetailViewModel

    init(viewModel: CharacterDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    private var character: CharacterModel { viewModel.character }

    var body: some View {
        List {
            Section {
                CharacterImage(url: character.imageURL)
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(maxWidth: 420)
                    .frame(maxWidth: .infinity)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            }

            Section {
                DetailRow(title: "Status", value: character.status.title, dotColor: character.status.color)
                DetailRow(title: "Species", value: character.species)
                DetailRow(title: "Gender", value: character.gender)
                DetailRow(title: "Location", value: character.locationName)
            }

            episodes
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.large)
        .task {
            do { try await viewModel.loadEpisodes() } catch { }
        }
    }

    @ViewBuilder
    private var episodes: some View {
        switch viewModel.state {
        case .loading:
            Section("Episodes") {
                ProgressView().frame(maxWidth: .infinity)
            }
        case .loaded(let sections):
            ForEach(sections) { section in
                Section("Season \(section.season)") {
                    ForEach(section.episodes) { EpisodeRow(episode: $0) }
                }
            }
        case .failed(let message):
            Section("Episodes") {
                Text(message).foregroundStyle(.secondary)
                Button("Try Again") {
                    Task { try? await viewModel.loadEpisodes() }
                }
            }
        }
    }
}

private struct DetailRow: View {
    let title: String
    let value: String
    var dotColor: Color?

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            if let dotColor {
                Circle().fill(dotColor).frame(width: 8, height: 8)
            }
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .accessibilityElement(children: .combine)
    }
}

private extension CharacterStatus {
    var color: Color {
        switch self {
        case .alive: .green
        case .dead: .red
        case .unknown: .gray
        }
    }
}

#Preview {
    NavigationStack {
        CharacterDetailView(viewModel: CharacterDetailViewModel(
            character: .sample,
            repository: EpisodeRepository(service: APIService())
        ))
    }
}
