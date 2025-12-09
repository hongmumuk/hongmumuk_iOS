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
        .background(.blue)
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
    ),
    .init(
        title: "제육볶음 장인",
        subtitle: "불타는 제육",
        category: .asian,
        views: 201,
        distance: 3
    ),
    .init(
        title: "연남동 감성 카페",
        subtitle: "브루잉데이",
        category: .chinese,
        views: 56,
        distance: 7
    ),
    .init(
        title: "떡볶이 레전드",
        subtitle: "할매분식",
        category: .snack,
        views: 310,
        distance: 2
    )
]
