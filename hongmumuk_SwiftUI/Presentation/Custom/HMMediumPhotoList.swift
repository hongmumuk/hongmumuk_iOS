import SwiftUI

struct HMMediumPhotoList: View {
    let cards: HMMediumPhotos
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(cards.items, id: \.id) { card in
                    HMMediumPhotoCard(card: card)
                }
            }
            .padding(.horizontal, 24)
        }
    }
}
