import SwiftUI

struct DetailView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    thumbnailImage()
                    thumbnailInfo()
                        .padding(.top, 253)
                }
                .ignoresSafeArea(.container, edges: .top)
                
                tags()
                content()
                
                Spacer(minLength: .infinity)
            }
            .toolbar(content: toolbar)
        }
    }
    
    // MARK: - toolbar
    
    private func toolbar() -> some View {
        Image(systemName: "xmark")
            .onTapGesture {}
    }
    
    // MARK: - thumbnailImage
    
    private func thumbnailImage() -> some View {
        Image("Thumbnail Image")
            .resizable()
            .scaledToFit()
            .overlay(content: thumbnailImageOverlay)
    }
    
    private func thumbnailImageOverlay() -> some View {
        return LinearGradient(
            colors: [.clear, .black.opacity(0.6)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // MARK: - thumbnailInfo
    
    private func thumbnailInfo() -> some View {
        HStack {
            thumbnailTitle()
            Spacer()
            thumbnailContent()
        }
        .padding(.leading, 20)
        .padding(.trailing, 24)
        .padding(.bottom, 56)
        .frame(height: 51)
    }
    
    private func thumbnailTitle() -> some View {
        VStack(alignment: .leading) {
            Text("Sub Title")
                .foregroundColor(.white)
                .fontStyle(Fonts.body2SemiBold)
                .padding(.bottom, 4)
            
            Text("Main Title")
                .foregroundColor(.white)
                .fontStyle(Fonts.heading1Bold)
        }
    }
    
    private func thumbnailContent() -> some View {
        VStack(alignment: .trailing) {
            Spacer()
            
            Text("Type")
                .foregroundColor(.white)
                .fontStyle(Fonts.caption1Medium)
                .padding(.bottom, 8)
            
            Text("Time")
                .foregroundColor(.white)
                .fontStyle(Fonts.caption1Medium)
        }
    }
    
    // MARK: - Tags
    
    private func tags() -> some View {
        let texts: [String] = ["#Tag", "#Tag", "#Tag"]
        
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
                .fontStyle(Fonts.body1SemiBold)
                .padding(.bottom, 32)
        }
    }
    
    private func address() -> some View {
        VStack(alignment: .leading) {
            Text("주소")
                .foregroundColor(Colors.Primary.normal)
                .fontStyle(Fonts.heading3Bold)
                .padding(.top, 8)
                .padding(.bottom, 8)
            
            Text("서울특별시 마포구 매운로 27, 김치타운빌딩 2층")
                .foregroundColor(Colors.GrayScale.grayscale60)
                .fontStyle(Fonts.body1Medium)
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
                .fontStyle(Fonts.body1SemiBold)
                .padding(.bottom, 4)
            
            Spacer()
            
            Text("\(price)원")
                .foregroundColor(Colors.GrayScale.grayscale60)
                .fontStyle(Fonts.body1SemiBold)
                .padding(.bottom, 4)
        }
    }
}
