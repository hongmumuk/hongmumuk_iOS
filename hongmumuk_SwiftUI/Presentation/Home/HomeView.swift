import SwiftUI

struct HomeView: View {
    @State var showDetail = false
    
    var body: some View {
        ScrollView(content: content)
            .fullScreenCover(isPresented: $showDetail, content: fullScreenContent)
            .padding(.top)
    }
    
    private func content() -> some View {
        VStack(spacing: 0) {
            HMLargeTitle(title: "오늘의 추천 맛집")
            HMLagePhotoList()
                .onTapGesture { showDetail = true }
            HMLargeTitle(title: "에디터 추천 5선")
            HMMediumPhotoList()
                .onTapGesture { showDetail = true }
            HMLargeTitle(title: "새로운 장소가 궁금하다면?")
            HMSmallPhotoList(items: tagSmallCards)
                .onTapGesture { showDetail = true }
            HMLargeTitle(title: "카테고리별로 볼래요")
            HMFilter(isImage: true)
            HMSmallPhotoList(items: categorySmallCards)
                .onTapGesture { showDetail = true }
            Spacer()
        }
    }
    
    private func fullScreenContent() -> some View {
        return DetailView()
    }
}
