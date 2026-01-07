import SwiftUI

struct HMSmallPhotoList: View {
    let cards: [any HMSmallPhoto]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(cards, id: \.id) { card in
                HMSmallPhotoCard(card: card)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
            }
        }
    }
}
