import SwiftUI

@Observable
class PartnerViewModel {
    var isLoading = true
    var selectedFitler: Category = .all
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
        // 1) 전체 버튼
        if category == .all {
            selectedFitler = .all
            displaySections = sections
            return
        }

        // 2) 같은 카테고리 재클릭 → 전체로 복귀
        if selectedFitler == category {
            selectedFitler = .all
            displaySections = sections
            return
        }

        // 3) 신규 카테고리 선택 → 필터링
        selectedFitler = category
        displaySections = filteredSections(for: category)
    }

    private func filteredSections(for category: Category) -> [any HM] {
        sections.compactMap { section in
            // category 섹션이 아니면 그대로 유지
            guard let categorySection = section as? HMPartnerSmallPhotos else {
                return section
            }

            // category 기준 아이템 필터
            let filteredItems: [HMPartnerSmallPhoto] = categorySection.items
                .compactMap { $0 as? HMPartnerSmallPhoto }
                .filter { $0.category == category }

            // 결과 없으면 섹션 제거
            guard !filteredItems.isEmpty else { return nil }

            // 필터된 섹션으로 교체
            return HMPartnerSmallPhotos(items: filteredItems)
        }
    }
}
