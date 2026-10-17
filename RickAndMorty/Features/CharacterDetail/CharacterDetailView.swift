import SwiftUI

struct CharacterDetailView: View {
    let character: CharacterModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CharacterImage(url: character.imageURL)
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(maxWidth: 420)

                VStack(spacing: 0) {
                    DetailRow(title: "Status", value: character.status.title, dotColor: character.status.color)
                    Divider()
                    DetailRow(title: "Species", value: character.species)
                    Divider()
                    DetailRow(title: "Gender", value: character.gender)
                    Divider()
                    DetailRow(title: "Location", value: character.locationName)
                }
                .padding(.horizontal)
                .background(.background.secondary, in: RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.large)
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
        .padding(.vertical, 12)
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
    NavigationStack { CharacterDetailView(character: .sample) }
}
