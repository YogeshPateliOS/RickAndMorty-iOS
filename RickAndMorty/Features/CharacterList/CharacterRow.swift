import SwiftUI

struct CharacterRow: View {
    let character: CharacterModel

    var body: some View {
        HStack(spacing: 12) {
            CharacterImage(url: character.imageURL)
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 2) {
                Text(character.name)
                    .font(.headline)
                Text("^[\(character.episodeCount) episode](inflect: true)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    List { CharacterRow(character: .sample) }.listStyle(.plain)
}
