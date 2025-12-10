import SwiftUI

struct HMMediumPhotoCard: View {
    let card: HMMediumPhoto
    let width: CGFloat = 200
    let height: CGFloat = 200
    let cornerRadius: CGFloat = 20
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let image = card.image {
                image
                    .resizable()
                    .scaledToFill()
            }
            HMImageOverlay()
            bottomStack()
        }
        .frame(width: width, height: height)
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
            Image("View")
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
            
            Text(card.subtitle)
                .foregroundColor(.white)
                .fontStyle(Fonts.body2SemiBold)
            
            Text(card.title)
                .foregroundColor(.white)
                .fontStyle(Fonts.heading2Bold)
        }
    }
}

struct HMMediumPhoto: Identifiable {
    let id = UUID()
    let image: Image? = nil
    let title: String
    let subtitle: String
    let views: Int
}
