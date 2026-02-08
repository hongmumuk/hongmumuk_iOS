import SwiftUI

struct PartnerlView: View {
    @State var showDetail = false
    var partnerViewModel: PartnerViewModel = .init()
    
    var body: some View {
        ScrollView(content: content)
            .fullScreenCover(isPresented: $showDetail, content: fullScreenContent)
            .padding(.top)
            .task {
                await partnerViewModel.getSections()
            }
    }
    
    @ViewBuilder
    private func content() -> some View {
        if !partnerViewModel.sections.isEmpty {
            VStack(spacing: 0) {
                ForEach(partnerViewModel.sections, id: \.id) { section in
                    switch section.type {
                    case .title:
                        if let item = section as? HMLTitle {
                            HMLargeTitle(title: item.title)
                        }
                        
                    case .partnerSmallPhoto:
                        if let item = section as? HMPartnerSmallPhotos {
                            VStack {
                                HMFilter(isImage: false)
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
