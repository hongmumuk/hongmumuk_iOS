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
            ForEach(partnerViewModel.sections, id: \.id) { section in
                switch section.type {
                case .filter:
                    HMFilter(categories: partnerViewModel.filters, isImage: false)
                    
                case .title:
                    if let item = section as? HMLTitle {
                        HMLargeTitle(title: item.title)
                    }
                    
                case .partnerSmallPhoto:
                    if let item = section as? HMPartnerSmallPhotos {
                        HMSmallPhotoList(cards: item.items) { _ in }
                    }
                    
                default:
                    EmptyView()
                }
            }
        } else {
            Text("데이터가 없습니다.")
        }
    }
}
