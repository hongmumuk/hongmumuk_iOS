import SwiftUI

struct HomeView: View {
    @State var showDetail = false
    @State var showPopup = false
    @State var homeViewModel: HomeViewModel = .init()
    
    //    var body: some View {
    //        ScrollView(content: content)
    //            .fullScreenCover(item: $homeViewModel.selectedItem, content: fullScreenContent)
    //            .padding(.top)
    //            .onAppear {
    //                Event.screenHome.send()
    //            }
    //            .task {
    //                await homeViewModel.getSections()
    //            }
    //    }
    
    var body: some View {
        ZStack {
            ScrollView(content: content)
                .disabled(showPopup)
                .blur(radius: showPopup ? 2 : 0)
            
            if showPopup {
                Color.black
                    .opacity(0.45)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismissPopup()
                    }
                
                HMPopupView(
                    onClose: dismissPopup,
                    onTapPost: {
                        dismissPopup()
                    }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(1)
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.9), value: showPopup)
        .task {
            await homeViewModel.getSections()

            // if !UserDefaultsManager.shared.isViewPopUp {
            if !showPopup {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showPopup = true
                }

                UserDefaultsManager.shared.isViewPopUp = true
            }
        }
    }
    
    private func dismissPopup() {
        showPopup = false
    }
    
    @ViewBuilder
    private func content() -> some View {
        if !homeViewModel.displaySections.isEmpty {
            LazyVStack(spacing: 0) {
                HMNavigationBar()
                
                ForEach(homeViewModel.displaySections, id: \.id) { section in
                    switch section.type {
                    case .filter:
                        HMFilter(
                            categories: homeViewModel.filters,
                            isImage: true,
                            selected: homeViewModel.selectedFitler
                        ) { category in
                            homeViewModel.selectFilter(for: category)
                        }
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
            ProgressView()
        }
    }
    
    private func fullScreenContent(for item: SelectedItem) -> some View {
        return DetailView(detailViewModel: DetailViewModel(selectedId: item.id))
    }
}
