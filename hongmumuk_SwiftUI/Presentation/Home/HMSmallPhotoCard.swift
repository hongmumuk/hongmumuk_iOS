import SwiftUI

struct HMSmallPhotoCard: View {
    let card: HMSmallPhoto
    private let size: CGFloat = 96
    let cornerRadius: CGFloat = 20
    
    var body: some View {
        HStack(spacing: 20) {
            imageStack()
            textStack()
            Spacer()
        }
    }
    
    private func imageStack() -> some View {
        ZStack {
            if let image = card.image {
                image
                    .resizable()
                    .scaledToFill()
            }
            
            HMImageOverlay()
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    private func textStack() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            tags()
            title()
            info()
        }
    }
    
    private func tags() -> some View {
        Text("\(card.tags.map { "#\($0)" }.joined(separator: " "))")
            .fontStyle(Fonts.body2SemiBold)
            .foregroundColor(Colors.Primary.normal)
            .padding(.bottom, 4)
    }
    
    private func title() -> some View {
        Text(card.title)
            .fontStyle(Fonts.heading2Bold)
            .padding(.bottom, 10)
    }
    
    private func info() -> some View {
        HStack(spacing: 12) {
            HStack(spacing: 4) {
                Image("riceIcon")
                    .renderingMode(.template)
                    .foregroundColor(Colors.GrayScale.grayscale50)
                    .frame(width: 16, height: 16)
                    
                Text("\(card.category.displayName)")
                    .foregroundColor(Colors.GrayScale.grayscale50)
                    .fontStyle(Fonts.caption1Medium)
            }
            
            HStack(spacing: 4) {
                Image("Clock")
                    .renderingMode(.template)
                    .foregroundColor(Colors.GrayScale.grayscale50)
                    .frame(width: 16, height: 16)
                    
                Text("도보 \(card.distance)분")
                    .foregroundColor(Colors.GrayScale.grayscale50)
                    .fontStyle(Fonts.caption1Medium)
            }
        }
    }
}

struct HMSmallPhoto: Identifiable {
    let id = UUID()
    let image: Image? = nil
    let title: String
    let tags: [String]
    let category: Category
    let distance: Int
}
