import SwiftUI

struct HMMediumPhotoCard: View {
    let card: HMMediumPhoto
    let width: CGFloat = 200
    let height: CGFloat = 200
    let cornerRadius: CGFloat = 20
    
    var body: some View {
        AsyncImage(url: URL(string: card.imageUrl))
            .frame(width: width, height: height)
            .overlay {
                ZStack(alignment: .bottomLeading) {
                    HMImageOverlay()
                    bottomStack()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    private func bottomStack() -> some View {
        VStack(alignment: .leading) {
            viewIcon()
            Spacer()
            titleStack()
        }
        .padding(20)
    }
    
    private func viewIcon() -> some View {
        HStack(spacing: 4) {
            Spacer()
            Image("view")
                .frame(width: 16, height: 16)
            
            Text("\(card.views)")
                .foregroundColor(.white)
                .fontStyle(Fonts.caption1Medium)
        }
        .frame(height: 17)
    }
    
    private func titleStack() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Spacer()
            
            Text(card.placeName)
                .foregroundColor(.white)
                .fontStyle(Fonts.body2SemiBold)
            
            Text(card.title)
                .foregroundColor(.white)
                .fontStyle(Fonts.heading2Bold)
        }
    }
}
