import SwiftUI
import Kingfisher

struct CharacterImage: View {
    let url: URL?

    var body: some View {
        if let url {
            KFImage(url)
                .placeholder { ProgressView() }
                .onFailureView { placeholder }
                .fade(duration: 0.2)
                .resizable()
                .scaledToFill()
                .background(.quaternary)
                .accessibilityHidden(true)
        } else {
            placeholder.accessibilityHidden(true)
        }
    }

    private var placeholder: some View {
        Rectangle()
            .fill(.quaternary)
            .overlay {
                Image(systemName: "person.crop.circle")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
            }
    }
}

#Preview("No image") {
    CharacterImage(url: nil).frame(width: 120, height: 120)
}
