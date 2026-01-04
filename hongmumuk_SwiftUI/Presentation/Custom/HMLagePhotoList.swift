import SwiftUI

struct HMLagePhotoList: View {
    var cards: HMLagePhotos
    
    var body: some View {
        GeometryReader { geo in
            let cardWidth = geo.size.width - 48
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(cards.items) { card in
                        HMLagePhotoCard(card: card, width: cardWidth)
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, 24)
            }
            .scrollTargetBehavior(.viewAligned)
        }
        .frame(height: 200)
    }
}
