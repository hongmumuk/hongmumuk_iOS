import SwiftUI

struct HMFilter: View {
    @State private var selected: Category? = nil
    private let categories: [Category] = Category.allCases.filter { $0 != .all }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    HMFilterButton(
                        imageName: category.rawValue,
                        title: category.displayName,
                        isSelected: category == selected
                    ) {
                        action(category)
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
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
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                image(for: imageName)
                title(for: title)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .frame(minWidth: 82, minHeight: 36)
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
