import SwiftUI

struct HMLagePhotoList: View {
    var cards: HMLagePhotos
    let onSelect: (String) -> Void
    
    var body: some View {
        let cardWidth = UIScreen.main.bounds.width - 48
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(cards.items) { card in
                    HMLagePhotoCard(card: card, width: cardWidth)
                        .contentShape(Rectangle())
                        .onTapGesture { onSelect(card.id) }
                }
            }
            .scrollTargetLayout()
            .padding(.horizontal, 24)
        }
        .scrollTargetBehavior(.viewAligned)
        .frame(height: 200)
    }
}
