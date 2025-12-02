import SwiftUI

struct HMMediumPhotoList: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(mediumCards) { card in
                    HMMediumPhotoCard(card: card)
                }
            }
            .padding(.horizontal, 24)
        }
        .background(.cyan)
    }
}

let mediumCards: [HMMediumPhoto] = [
    .init(
        title: "연남동 브런치 맛집",
        subtitle: "소소한식탁",
        views: 128
    ),
    .init(
        title: "제주 감성 카페",
        subtitle: "오후의바다",
        views: 342
    ),
    .init(
        title: "가성비 파스타",
        subtitle: "쿠치나데이",
        views: 97
    ),
    .init(
        title: "한우 스테이크",
        subtitle: "미트하우스",
        views: 521
    ),
    .init(
        title: "레트로 분식집",
        subtitle: "할매떡볶이",
        views: 214
    )
]
