import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    var detailViewModel: DetailViewModel
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                if detailViewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ZStack(alignment: .bottom) {
                                thumbnailTab()
                                thumbnailInfo()
                            }
                            
                            tags()
                            subtitle()
                            description()
                            address()
                            menu()
                        }
                        .padding(.bottom, 81)
                    }
                    .ignoresSafeArea(edges: .top)
                }
                
                dismissButton()
            }
        }
        .onAppear {
            detailViewModel.onAppear()
        }
    }
    
    // MARK: - thumbnailImage
    
    private func thumbnailTab() -> some View {
        TabView {
            if detailViewModel.images.isEmpty {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(content: thumbnailImageOverlay)
            } else {
                ForEach(detailViewModel.images, id: \.self) { imageUrl in
                    AsyncImage(url: URL(string: imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .overlay(content: thumbnailImageOverlay)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: 402)
    }
    
    private func thumbnailImageOverlay() -> some View {
        return LinearGradient(
            colors: [.clear, .black.opacity(0.6)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private func dismissButton() -> some View {
        Image("xmark")
            .resizable()
            .scaledToFit()
            .frame(width: 36, height: 36)
            .onTapGesture { dismiss() }
            .padding(.top, 12)
            .padding(.trailing, 24)
    }
    
    // MARK: - thumbnailInfo
    
    private func thumbnailInfo() -> some View {
        HStack {
            thumbnailTitle()
            Spacer()
            thumbnailContent()
        }
        .frame(height: 51)
        .padding(.leading, 20)
        .padding(.trailing, 24)
        .padding(.bottom, 56)
    }
    
    private func thumbnailTitle() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            // placeName이 있으면 상단에 표시
            if !detailViewModel.placeName.isEmpty {
                Text(detailViewModel.placeName)
                    .foregroundColor(.white)
                    .fontStyle(Fonts.body2SemiBold)
            }
            
            // title
            if !detailViewModel.title.isEmpty {
                Text(detailViewModel.title)
                    .foregroundColor(.white)
                    .fontStyle(Fonts.heading1Bold)
            }
        }
    }
    
    private func thumbnailContent() -> some View {
        VStack(alignment: .trailing, spacing: 8) {
            Spacer()
            if let category = detailViewModel.category {
                categoryView(for: category.displayName)
            }
            if let walkTime = detailViewModel.walkTime {
                distance(for: walkTime)
            }
        }
    }
    
    private func categoryView(for text: String) -> some View {
        HStack(spacing: 4) {
            Image("riceIcon")
                .renderingMode(.template)
                .foregroundColor(.white)
                .frame(width: 16, height: 16)
            
            Text("\(text)")
                .foregroundColor(.white)
                .fontStyle(Fonts.caption1Medium)
        }
    }
    
    private func distance(for time: Int) -> some View {
        HStack(spacing: 4) {
            Image("Clock")
                .renderingMode(.template)
                .foregroundColor(.white)
                .frame(width: 16, height: 16)
            
            Text("도보 \(time)분")
                .foregroundColor(.white)
                .fontStyle(Fonts.caption1Medium)
        }
    }
    
    // MARK: - Tags
    
    @ViewBuilder
    private func tags() -> some View {
        if !detailViewModel.tags.isEmpty {
            HStack(spacing: 4) {
                ForEach(detailViewModel.tags, id: \.self) { tag in
                    tagCapsule(text: "# \(tag)")
                }
                
                Spacer()
            }
            .padding(.leading, 24)
            .frame(height: 57)
        }
    }
    
    private func tagCapsule(text: String) -> some View {
        Text(text)
            .foregroundColor(Colors.Label.Normal.neutral)
            .fontStyle(Fonts.caption1Regular)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(content: tagCapsuleBackgroud)
    }
    
    private func tagCapsuleBackgroud() -> some View {
        Capsule()
            .fill(Colors.Label.Normal.disable)
    }
    
    // MARK: - Content
    
    @ViewBuilder
    private func subtitle() -> some View {
        if !detailViewModel.subtitle.isEmpty {
            HStack {
                Text(detailViewModel.subtitle)
                    .foregroundColor(Colors.Label.Normal.normal)
                    .fontStyle(Fonts.heading2Bold)
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    @ViewBuilder
    private func description() -> some View {
        if !detailViewModel.description.isEmpty {
            HStack {
                Text(detailViewModel.description)
                    .foregroundColor(Colors.Label.Normal.basic)
                    .fontStyle(Fonts.heading3Medium)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    @ViewBuilder
    private func address() -> some View {
        if !detailViewModel.address.isEmpty {
            VStack(alignment: .leading) {
                Text("주소")
                    .foregroundColor(Colors.Primary.normal)
                    .fontStyle(Fonts.heading3Bold)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                
                Text(detailViewModel.address)
                    .foregroundColor(Colors.Label.Normal.basic)
                    .fontStyle(Fonts.heading3Medium)
                    .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
        }
    }
    
    @ViewBuilder
    private func menu() -> some View {
        if !detailViewModel.menus.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                Text("메뉴")
                    .foregroundColor(Colors.Primary.normal)
                    .fontStyle(Fonts.heading3Bold)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                
                VStack(spacing: 4) {
                    ForEach(detailViewModel.menus) { menu in
                        menuStack(for: menu.name, price: menu.price ?? 0)
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    private func menuStack(for menu: String, price: Int) -> some View {
        HStack {
            Text(menu)
                .foregroundColor(Colors.Label.Normal.basic)
                .fontStyle(Fonts.heading3Medium)
            
            Spacer()
            
            Text("\(price)원")
                .foregroundColor(Colors.Label.Normal.basic)
                .fontStyle(Fonts.heading3Regular)
        }
    }
}
