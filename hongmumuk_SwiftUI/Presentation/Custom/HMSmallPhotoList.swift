import SwiftUI

struct HMSmallPhotoList: View {
    let cards: [any HMSmallPhoto]
    let onSelect: (String) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(cards, id: \.id) { card in
                HMSmallPhotoCard(card: card)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .onTapGesture { onSelect(card.id.uuidString) }
            }
        }
    }
}
