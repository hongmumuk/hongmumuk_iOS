import SwiftUI

struct PartnerlView: View {
    @State var showDetail = false
    var partnerViewModel: PartnerViewModel = .init()
    
    var body: some View {
        ScrollView(content: content)
            .padding(.top)
            .task {
                await partnerViewModel.getSections()
            }
    }
    
    @ViewBuilder
    private func content() -> some View {
        if !partnerViewModel.displaySections.isEmpty {
            LazyVStack(spacing: 16) {
                ForEach(partnerViewModel.displaySections, id: \.id) { section in
                    switch section.type {
                    case .filter:
                        HMFilter(categories: partnerViewModel.filters, isImage: false) { category in
                            partnerViewModel.selectFilter(for: category)
                        }
                        .padding(.bottom, 8)
                        
                    case .title:
                        if let item = section as? HMLTitle {
                            HMLargeTitle(title: item.title)
                                .padding(.bottom, 4)
                        }
                        
                    case .partnerSmallPhoto:
                        if let item = section as? HMPartnerSmallPhotos {
                            HMSmallPhotoList(cards: item.items) { _ in }
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
}
