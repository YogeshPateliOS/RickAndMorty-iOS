import SwiftUI

struct EpisodeRow: View {
    let episode: EpisodeModel

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(episode.name)
            Text("\(episode.code) · \(episode.airDate)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }
}
