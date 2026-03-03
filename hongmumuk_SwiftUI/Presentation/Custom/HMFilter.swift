import SwiftUI

struct HMFilter: View {
    @State private var selected: Category? = nil
    let categories: [Category]
    let isImage: Bool
    let onSelcted: (Category) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    HMFilterButton(
                        imageName: category.rawValue,
                        title: category.displayName,
                        isSelected: category == selected,
                        isImage: isImage
                    ) {
                        onSelcted(category)
                        action(category)
                    }
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 16)
            .padding(.horizontal, 24)
        }
    }
    
    private func action(_ category: Category) {
        if selected == category {
            selected = nil
        } else {
            selected = category
        }
    }
}

struct HMFilterButton: View {
    let imageName: String?
    let title: String
    let isSelected: Bool
    let isImage: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if isImage {
                    image(for: imageName)
                }
                
                title(for: title)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(content: backgroundContent)
            .shadow(color: .black.opacity(0.05), radius: 12)
        }
    }
    
    @ViewBuilder
    private func image(for imageName: String?) -> some View {
        if let imageName {
            Image(imageName)
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
    
    private func title(for text: String) -> some View {
        Text(text)
            .foregroundColor(Colors.GrayScale.grayscale70)
            .fontStyle(Fonts.heading3Bold)
    }
    
    private func backgroundContent() -> some View {
        RoundedRectangle(cornerRadius: 999)
            .fill(isSelected ? Colors.Label.Normal.disable : .white)
    }
}
