import SwiftUI

@Observable
class PartnerViewModel {
    var isLoading = true
    var selectedFitler: Category?
    var sections: [any HM] = []
    var displaySections: [any HM] = []
    var filters: [Category] = Category.filterPartner()
    
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
            
            displaySections = sections
        } catch {
            print("error", error)
        }
    }
    
    private func fetchCategorySmallPhoto(for items: [HomeItem]) -> HMPartnerSmallPhotos {
        var result: [HMPartnerSmallPhoto] = []

        for item in items {
            let newItem: HMPartnerSmallPhoto = .init(
                id: item.id,
                title: item.title ?? "",
                subTitle: item.placeName ?? "",
                address: item.address ?? "",
                imageUrl: item.image ?? "",
                tag: item.partnerSubcategoryLabel ?? "",
                category: .init(rawValue: item.partnerCategoryKey ?? "") ?? .life,
            )

            result.append(newItem)
        }

        return .init(items: result)
    }
    
    func selectFilter(for category: Category) {
        if selectedFitler == category {
            displaySections = sections
            selectedFitler = nil
            return
        } else {
            selectedFitler = category
        }

        displaySections = sections.compactMap { section in
            // categorySmallPhoto가 아니면 그대로 유지
            guard let categorySection = section as? HMPartnerSmallPhotos else {
                return section
            }

            // category 기준 필터링
            let filteredItems = categorySection.items
                .compactMap { $0 as? HMPartnerSmallPhoto }
                .filter { $0.category == category }

            // 필터 결과가 없으면 섹션 제거
            guard !filteredItems.isEmpty else {
                return nil
            }

            // 필터된 categorySmallPhoto 섹션만 교체
            return HMPartnerSmallPhotos(items: filteredItems)
        }
    }
}
