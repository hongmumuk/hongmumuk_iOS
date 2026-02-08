import SwiftUI

@Observable
class PartnerViewModel {
    var isLoading = true
    var sections: [any HM] = []
    
    func getSections() async {
        if !sections.isEmpty {
            sections = []
        }
        
        do {
            let items = try await SupabaseService.shared.getScreen(for: .partner)
            
            for section in items.sections {
                if let title = section.props.title {
                    let item = HMLTitle(title: title)
                    sections.append(item)
                }
                
                if section.type == .categoryFilterList {
                    let item = fetchCategorySmallPhoto(for: section.items)
                    sections.append(item)
                }
            }
        } catch {
            print("error", error)
        }
    }
    
    private func fetchCategorySmallPhoto(for items: [HomeItem]) -> HMPartnerSmallPhotos {
        var result: [HMPartnerSmallPhoto] = []
        
        for item in items {
            let newItem: HMPartnerSmallPhoto = .init(
                title: item.mainTitle,
                subTitle: item.subTitle ?? "",
                address: "서울 마포구 홍익로 4 아남빌딩 2층",
                imageUrl: item.heroImageUrl ?? "",
                category: .korean
            )
            
            result.append(newItem)
        }
        
        return .init(items: result)
    }
}
