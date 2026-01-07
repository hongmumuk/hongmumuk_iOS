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
        if !homeViewModel.sections.isEmpty {
            VStack(spacing: 0) {
                ForEach(homeViewModel.sections, id: \.id) { section in
                    switch section.type {
                    case .title:
                        if let item = section as? HMLTitle {
                            HMLargeTitle(title: item.title)
                        }
                        
                    case .largePhoto:
                        if let item = section as? HMLagePhotos {
                            HMLagePhotoList(cards: item)
                        }
                        
                    case .mediumPhoto:
                        if let item = section as? HMMediumPhotos {
                            HMMediumPhotoList(cards: item)
                        }
                        
                    case .tagSmallPhoto:
                        if let item = section as? HMTagSmallPhotos {
                            HMSmallPhotoList(cards: item.items)
                        }
                        
                    case .categorySmallPhoto:
                        if let item = section as? HMCategorySmallPhotos {
                            VStack {
                                HMFilter(isImage: true)
                                HMSmallPhotoList(cards: item.items)
                            }
                        }
                        
                    default:
                        EmptyView()
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
