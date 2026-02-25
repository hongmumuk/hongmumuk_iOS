import SwiftUI

struct PartnerlView: View {
    @State var showDetail = false
    var partnerViewModel: PartnerViewModel = .init()
    
    var body: some View {
        ScrollView(content: content)
            .padding(.top)
            .task {
                try? await SupabaseService.shared.getScreenJson(for: .partner)
                await partnerViewModel.getSections()
            }
    }
    
    @ViewBuilder
    private func content() -> some View {
        if !partnerViewModel.sections.isEmpty {
            LazyVStack(spacing: 16) {
                ForEach(partnerViewModel.sections, id: \.id) { section in
                    switch section.type {
                    case .filter:
                        HMFilter(categories: partnerViewModel.filters, isImage: false)
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
            Text("데이터가 없습니다.")
        }
    }
}
