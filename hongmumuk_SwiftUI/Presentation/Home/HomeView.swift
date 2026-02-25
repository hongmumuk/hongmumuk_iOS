import SwiftUI

struct HomeView: View {
    @State var showDetail = false
    @Bindable var homeViewModel: HomeViewModel = .init()
    
    var body: some View {
        ScrollView(content: content)
            .fullScreenCover(item: $homeViewModel.selectedItem, content: fullScreenContent)
            .padding(.top)
            .task {
                await homeViewModel.getSections()
            }
    }
    
    @ViewBuilder
    private func content() -> some View {
        if !homeViewModel.sections.isEmpty {
            LazyVStack(spacing: 16) {
                ForEach(homeViewModel.sections, id: \.id) { section in
                    switch section.type {
                    case .filter:
                        HMFilter(categories: homeViewModel.filters, isImage: true)
                            .padding(.bottom, 8)
                        
                    case .title:
                        if let item = section as? HMLTitle {
                            HMLargeTitle(title: item.title)
                                .padding(.bottom, 4)
                        }
                        
                    case .largePhoto:
                        if let item = section as? HMLagePhotos {
                            HMLagePhotoList(cards: item) { id in
                                homeViewModel.selectItem(for: id)
                            }
                            .padding(.bottom, 8)
                        }
                        
                    case .mediumPhoto:
                        if let item = section as? HMMediumPhotos {
                            HMMediumPhotoList(cards: item) { id in
                                homeViewModel.selectItem(for: id)
                            }
                            .padding(.bottom, 8)
                        }
                        
                    case .tagSmallPhoto:
                        if let item = section as? HMTagSmallPhotos {
                            HMSmallPhotoList(cards: item.items) { id in
                                homeViewModel.selectItem(for: id)
                            }
                            .padding(.bottom, 8)
                        }
                        
                    case .categorySmallPhoto:
                        if let item = section as? HMCategorySmallPhotos {
                            HMSmallPhotoList(cards: item.items) { id in
                                homeViewModel.selectItem(for: id)
                            }
                            .padding(.bottom, 8)
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
    
    private func fullScreenContent(for item: SelectedItem) -> some View {
        return DetailView(detailViewModel: DetailViewModel(selectedId: item.id))
    }
}
