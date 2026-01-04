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
    }
}

let mediumCards: [HMMediumPhoto] = [
    .init(
        title: "퀄리티 높은 한식집",
        subtitle: "미로식당",
        views: 100
    ),
    .init(
        title: "리듬타며 과제할 때",
        subtitle: "렉터스 라운지",
        views: 1
    )
]
