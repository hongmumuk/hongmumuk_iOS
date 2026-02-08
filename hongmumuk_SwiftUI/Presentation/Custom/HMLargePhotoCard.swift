import SwiftUI

struct HMLagePhotoCard: View {
    let card: HMLagePhoto
    let width: CGFloat
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
        VStack {
            viewIcon()
            Spacer()
            HStack {
                titleStack()
                Spacer()
                infoStack()
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 20)
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
        .padding(.top, 20)
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
    
    private func infoStack() -> some View {
        VStack(alignment: .trailing, spacing: 8) {
            Spacer()
            
            HStack(spacing: 4) {
                Image("riceIcon")
                    .frame(width: 16, height: 16)
                
                Text("\(card.category.displayName)")
                    .foregroundColor(.white)
                    .fontStyle(Fonts.caption1Medium)
            }
            
            HStack(spacing: 4) {
                Image("Clock")
                    .frame(width: 16, height: 16)
                
                Text("도보 \(card.distance)분")
                    .foregroundColor(.white)
                    .fontStyle(Fonts.caption1Medium)
            }
        }
    }
}
