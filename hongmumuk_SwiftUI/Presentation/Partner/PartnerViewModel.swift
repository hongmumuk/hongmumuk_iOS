import SwiftUI

@Observable
class PartnerViewModel {
    var isLoading = true
    var sections: [any HM] = []
    
    func getSections() async {
        if !sections.isEmpty {
            return
        }
        
        do {
            let items = try await SupabaseService.shared.getScreen(for: .partner)
            
            for section in items.sections {
                if section.type == .categoryFilterList {
                    sections.append(HMListFilter())
                }
                
                if let title = section.props.title {
                    let item = HMLTitle(title: title)
                    sections.append(item)
                }
                
                let item = fetchCategorySmallPhoto(for: section.items)
                sections.append(item)
            }
        } catch {
            print("error", error)
        }
    }
    
    private func fetchCategorySmallPhoto(for items: [HomeItem]) -> HMPartnerSmallPhotos {
        var result: [HMPartnerSmallPhoto] = []

        for item in items {
            let newItem: HMPartnerSmallPhoto = .init(
                title: item.title ?? "",
                subTitle: item.placeName ?? "",
                address: item.address ?? "",
                imageUrl: item.image ?? "",
                tag: item.partnerSubcategoryLabel ?? ""
            )

            result.append(newItem)
        }

        return .init(items: result)
    }
}
