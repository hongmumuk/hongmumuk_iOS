import SwiftUI

struct HomeView: View {
    @State var showDetail = false
    var homeViewModel: HomeViewModel = .init()
    
    var body: some View {
        ScrollView(content: content)
            .fullScreenCover(isPresented: $showDetail, content: fullScreenContent)
            .padding(.top)
            .task {
                await homeViewModel.getSections()
            }
    }
    
    @ViewBuilder
    private func content() -> some View {
        if let sections = homeViewModel.items?.sections {
            VStack(spacing: 0) {
                ForEach(sections) { section in
                    print("title", section.props.title)
                    
                    return VStack(spacing: 0) {
                        if let title = section.props.title {
                            HMLargeTitle(title: title)
                        }
                        
                        switch section.type {
                        case .cards:
                            switch section.props.cardStyle {
                            case .large:
                                HMLagePhotoList()
                                    .onTapGesture { showDetail = true }
                            case .medium:
                                HMMediumPhotoList()
                                    .onTapGesture { showDetail = true }
                            case .small:
                                HMSmallPhotoList(items: tagSmallCards)
                                    .onTapGesture { showDetail = true }
                            case .none:
                                Spacer()
                            }
                        case .categoryFilterList:
                            VStack(spacing: 0) {
                                HMFilter(isImage: true)
                                HMSmallPhotoList(items: categorySmallCards)
                                    .onTapGesture { showDetail = true }
                            }
                        }
                    }
                }
            }
        } else {
            Text("데이터가 없습니다.")
        }
    }
    
    private func fullScreenContent() -> some View {
        return DetailView()
    }
}

//            HMLargeTitle(title: "오늘의 추천 맛집")
//            HMLagePhotoList()
//                .onTapGesture { showDetail = true }
//            HMLargeTitle(title: "에디터 추천 5선")
//            HMMediumPhotoList()
//                .onTapGesture { showDetail = true }
//            HMLargeTitle(title: "새로운 장소가 궁금하다면?")
//            HMSmallPhotoList(items: tagSmallCards)
//                .onTapGesture { showDetail = true }
//            HMLargeTitle(title: "카테고리별로 볼래요")
//            HMFilter(isImage: true)
//            HMSmallPhotoList(items: categorySmallCards)
//                .onTapGesture { showDetail = true }
//            Spacer()
