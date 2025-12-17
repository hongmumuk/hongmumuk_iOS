import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                ScrollView {
                    VStack(spacing: 0) {
                        ZStack(alignment: .bottom) {
                            thumbnailTab()
                            thumbnailInfo()
                        }
                        
                        tags()
                        content()
                    }
                }
                .ignoresSafeArea(edges: .top)
                
                dismissButton()
            }
        }
    }
    
    // MARK: - thumbnailImage
    
    private func thumbnailTab() -> some View {
        let colors: [Color] = [.red, .orange, .blue, .green]
        
        return TabView {
            ForEach(colors, id: \.self) { color in
                // 이미지로 교체 필요
                Rectangle()
                    .fill(color)
                    .overlay(content: thumbnailImageOverlay)
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
        VStack(alignment: .leading) {
            Text("집밥김치찌개")
                .foregroundColor(.white)
                .fontStyle(Fonts.body2SemiBold)
                .padding(.bottom, 4)
            
            Text("김치찌개로 건물 세운 집")
                .foregroundColor(.white)
                .fontStyle(Fonts.heading1Bold)
        }
    }
    
    private func thumbnailContent() -> some View {
        VStack(alignment: .trailing) {
            Spacer()
            category(for: "한식").padding(.bottom, 8)
            distance(for: 10)
        }
    }
    
    private func category(for text: String) -> some View {
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
    
    private func tags() -> some View {
        let texts: [String] = ["#한식", "#베스트"]
        
        return HStack(spacing: 4) {
            ForEach(texts, id: \.self) { text in
                tagCapsule(text: text)
            }
            
            Spacer()
        }
        .padding(.leading, 24)
        .frame(height: 57)
    }
    
    private func tagCapsule(text: String) -> some View {
        Text(text)
            .foregroundColor(Colors.Primary.normal)
            .fontStyle(Fonts.caption1Regular)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(content: tagCapsuleBackgroud)
    }
    
    private func tagCapsuleBackgroud() -> some View {
        Capsule()
            .fill(Colors.Primary.primary10)
    }
    
    // MARK: - Content
    
    private func content() -> some View {
        VStack(alignment: .leading) {
            resInfo()
            address()
            menu()
        }
        .padding(.horizontal, 24)
    }
    
    private func resInfo() -> some View {
        VStack(alignment: .leading) {
            Text("밥도둑 끝판왕, 김치찌개")
                .foregroundColor(Colors.GrayScale.grayscale70)
                .fontStyle(Fonts.heading2Bold)
                .padding(.bottom, 8)
            
            Text("김치찌개는 언제 먹어도 치트키 같은 존재입니다. 얼큰함에 중독되고, 깊은 발효 맛에 취하는 순간, 그게 바로 K-소울푸드의 매력입니다. 이번 큐레이션에서는 전통 밥상 감성부터 힙한 퓨전 변주까지, 김치찌개의 무드를 한눈에 담아봅니다.")
                .foregroundColor(Colors.GrayScale.grayscale60)
                .fontStyle(Fonts.heading3Medium)
                .padding(.bottom, 32)
        }
    }
    
    private func address() -> some View {
        VStack(alignment: .leading) {
            Text("주소")
                .foregroundColor(Colors.Primary.normal)
                .fontStyle(Fonts.heading3Bold)
                .padding(.top, 12)
                .padding(.bottom, 8)
            
            Text("서울특별시 마포구 매운로 27, 김치타운빌딩 2층")
                .foregroundColor(Colors.GrayScale.grayscale60)
                .fontStyle(Fonts.heading3Medium)
                .padding(.bottom, 12)
        }
    }
    
    private func menu() -> some View {
        struct Menu: Hashable {
            var name: String
            var price: Int
        }
        
        let menus: [Menu] = [
            Menu(name: "김치찌개", price: 0),
            Menu(name: "계란말이", price: 0),
            Menu(name: "공기밥", price: 0)
        ]
        
        return VStack(alignment: .leading, spacing: 0) {
            Text("메뉴")
                .foregroundColor(Colors.Primary.normal)
                .fontStyle(Fonts.heading3Bold)
                .padding(.top, 12)
                .padding(.bottom, 9)
            
            VStack(spacing: 4) {
                ForEach(menus, id: \.self) { menu in
                    menuStack(for: menu.name, price: menu.price)
                }
            }
        }
    }
    
    private func menuStack(for menu: String, price: Int) -> some View {
        HStack {
            Text(menu)
                .foregroundColor(Colors.GrayScale.grayscale60)
                .fontStyle(Fonts.heading3Medium)
            
            Spacer()
            
            Text("\(price)원")
                .foregroundColor(Colors.GrayScale.grayscale60)
                .fontStyle(Fonts.heading3Regular)
        }
    }
}
