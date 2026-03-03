import Kingfisher
import SwiftUI

struct HMSmallPhotoCard: View {
    let card: any HMSmallPhoto
    @State private var isLoaded = false
    private let size: CGFloat = 96
    private let cornerRadius: CGFloat = 20
    
    var body: some View {
        HStack(spacing: 20) {
            imageStack()
            textStack()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func imageStack() -> some View {
        if let url = URL(string: card.imageUrl) {
            KFImage(url)
                .onSuccess { _ in
                    isLoaded = true
                }
                .onFailure { _ in
                    isLoaded = false
                }
                .placeholder {
                    thumbnailImage
                }
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .overlay {
                    if isLoaded {
                        ZStack(alignment: .bottomLeading) {
                            HMImageOverlay()
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        } else {
            thumbnailImage
        }
    }
    
    private func textStack() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            tags()
            subTtitle()
            title()
            info()
        }
    }
}

// MARK: - Image

extension HMSmallPhotoCard {
    private var thumbnailImage: some View {
        Image("thumbnailBigIcon")
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

// MARK: - Tags

extension HMSmallPhotoCard {
    @ViewBuilder
    private func tags() -> some View {
        if let card = card as? HMTagSmallPhoto {
            text(for: card.tags.map { "#\($0)" }.joined(separator: " "))
        } else if let card = card as? HMCategorySmallPhoto {
            text(for: card.tag)
        } else if let card = card as? HMPartnerSmallPhoto {
            textBadge(for: card.tag)
        } else {
            EmptyView()
        }
    }
    
    private func text(for text: String) -> some View {
        Text(text)
            .fontStyle(Fonts.body2SemiBold)
            .foregroundColor(Colors.Primary.normal)
            .padding(.bottom, 4)
    }
    
    private func textBadge(for text: String) -> some View {
        Text(text)
            .fontStyle(Fonts.caption1Semibold)
            .foregroundColor(Colors.Primary.normal)
            .padding(.vertical, 2)
            .padding(.horizontal, 4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Colors.Primary.primary10)
            )
            .padding(.bottom, 4)
    }
}

// MARK: - SubTtitle

extension HMSmallPhotoCard {
    @ViewBuilder
    private func subTtitle() -> some View {
        if let card = card as? HMPartnerSmallPhoto {
            Text(card.subTitle)
                .fontStyle(Fonts.caption1Medium)
                .foregroundColor(Colors.Label.Normal.neutral)
                .padding(.bottom, 4)
        }
    }
}

// MARK: - Title

extension HMSmallPhotoCard {
    private func title() -> some View {
        let isBenifit = card is HMPartnerSmallPhoto
        return Text(card.title)
            .fontStyle(isBenifit ? Fonts.heading3Bold : Fonts.heading2Bold)
            .lineLimit(1)
            .truncationMode(.tail)
            .padding(.bottom, 10)
    }
}

// MARK: - Info

extension HMSmallPhotoCard {
    @ViewBuilder
    private func info() -> some View {
        if let card = card as? HMPartnerSmallPhoto {
            address(for: card.address)
        } else if let card = card as? HMTagSmallPhoto {
            HStack(spacing: 12) {
                category(for: card.category)
                distance(for: card.distance)
            }
        } else if let card = card as? HMCategorySmallPhoto {
            HStack(spacing: 12) {
                category(for: card.category)
                distance(for: card.distance)
            }
        }
    }
    
    private func address(for text: String) -> some View {
        HStack(spacing: 4) {
            Image("mapPinLine")
                .frame(width: 16, height: 16)
            
            Text(text)
                .foregroundColor(Colors.GrayScale.grayscale50)
                .fontStyle(Fonts.caption1Medium)
        }
    }
    
    private func category(for category: Category) -> some View {
        HStack(spacing: 4) {
            Image(category.lineIconName)
                .renderingMode(.template)
                .foregroundColor(Colors.GrayScale.grayscale50)
                .frame(width: 16, height: 16)
            
            Text(category.displayName)
                .foregroundColor(Colors.GrayScale.grayscale50)
                .fontStyle(Fonts.caption1Medium)
        }
    }
    
    private func distance(for time: Int) -> some View {
        HStack(spacing: 4) {
            Image("Clock")
                .renderingMode(.template)
                .foregroundColor(Colors.GrayScale.grayscale50)
                .frame(width: 16, height: 16)
            
            Text("도보 \(time)분")
                .foregroundColor(Colors.GrayScale.grayscale50)
                .fontStyle(Fonts.caption1Medium)
        }
    }
}
