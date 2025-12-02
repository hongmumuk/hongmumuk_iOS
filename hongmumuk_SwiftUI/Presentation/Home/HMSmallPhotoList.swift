import SwiftUI

struct HMSmallPhotoList: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(smallCards) { card in
                HMSmallPhotoCard(card: card)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
            }
        }
        .background(.green)
    }
}

let smallCards: [HMSmallPhoto] = [
    .init(
        title: "연남동 브런치",
        tags: ["브런치", "감성", "사진맛집"],
        category: .asian,
        distance: 3
    ),
    .init(
        title: "불타는 제육",
        tags: ["제육", "매콤", "밥도둑"],
        category: .chinese,
        distance: 5
    ),
    .init(
        title: "집밥 김치찌개",
        tags: ["김치찌개", "한식", "혼밥"],
        category: .korean,
        distance: 2
    )
]
