import SwiftUI

struct HMLagePhotoList: View {
    var body: some View {
        GeometryReader { geo in
            let cardWidth = geo.size.width - 48
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(cards) { card in
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

let cards: [HMLagePhoto] = [
    .init(
        title: "김치찌개로 건물 세운 집",
        subtitle: "집밥김치찌개",
        category: .korean,
        views: 124,
        distance: 10
    ),
    .init(
        title: "된장찌개 맛집",
        subtitle: "정성된장",
        category: .korean,
        views: 89,
        distance: 5
    )
]
