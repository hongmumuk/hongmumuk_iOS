import SwiftUI

struct HMMediumPhotoList: View {
    let cards: HMMediumPhotos
    let onSelect: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(cards.items, id: \.id) { card in
                    HMMediumPhotoCard(card: card)
                        .contentShape(Rectangle())
                        .onTapGesture { onSelect(card.id) }
                }
            }
            .padding(.horizontal, 24)
        }
    }
}
