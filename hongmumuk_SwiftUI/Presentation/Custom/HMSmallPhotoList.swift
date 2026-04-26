import SwiftUI

struct HMSmallPhotoList: View {
    let cards: [any HMSmallPhoto]
    let onSelect: (String) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            mainView()
        }
    }
}

extension HMSmallPhotoList {
    @ViewBuilder
    private func mainView() -> some View {
        if cards.isEmpty {
            EmptyPlaceView()
        } else {
            ForEach(cards, id: \.id) { card in
                HMSmallPhotoCard(card: card)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())
                    .onTapGesture { onSelect(card.id) }
            }
        }
    }
}
