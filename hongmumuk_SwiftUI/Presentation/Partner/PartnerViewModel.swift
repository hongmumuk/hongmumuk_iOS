import SwiftUI

@Observable
class PartnerViewModel {
    var selectedFitler: Category = .all
    var sections: [any HM] = []
    var displaySections: [any HM] = []
    var filters: [Category] = Category.filterPartner()

    // id → HMPartnerSmallPhoto 룩업 - 카드 탭 이벤트에 활용
    private var partnerItemMap: [String: HMPartnerSmallPhoto] = [:]

    func getSections() async {
        if !sections.isEmpty {
            return
        }

        do {
            let items = try await SupabaseService.shared.getScreen(for: .partner)

            for section in items.sections {
                if section.type == .categoryFilterList {
                    sections.append(HMListFilter())
                    if !section.items.isEmpty {
                        sections.append(fetchCategorySmallPhoto(for: section.items))
                    }
                    continue
                }

                if let title = section.props.title {
                    sections.append(HMLTitle(title: title))
                }

                if !section.items.isEmpty {
                    sections.append(fetchCategorySmallPhoto(for: section.items))
                }
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
                title: item.placeName ?? "",
                subTitle: item.title ?? "",
                address: item.address ?? "",
                imageUrl: item.image ?? "",
                tag: item.partnerSubcategoryLabel ?? "",
                category: .init(rawValue: item.partnerCategoryKey ?? "") ?? .shopping,
            )
            partnerItemMap[item.id] = newItem
            result.append(newItem)
        }

        return .init(items: result)
    }

    func selectItem(for id: String) {
        guard let item = partnerItemMap[id] else { return }
        Event.partnerCardTapped(
            placeId: id,
            placeName: item.title,
            category: item.category.displayName
        ).send()
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
        Event.partnerCategoryFilterSelected(category: category.displayName).send()
    }

    private func filteredSections(for category: Category) -> [any HM] {
        let filtered: [any HM] = sections.compactMap { section in
            guard let photoSection = section as? HMPartnerSmallPhotos else {
                return section
            }
            let firstCategory = (photoSection.items.first as? HMPartnerSmallPhoto)?.category
            return firstCategory == category ? photoSection : nil
        }
        
        let hasResult = filtered.contains { $0 is HMPartnerSmallPhotos }
        guard hasResult else { return [] }
        
        return filtered.enumerated().compactMap { index, section in
            guard section is HMLTitle else { return section }
            let next = filtered.indices.contains(index + 1) ? filtered[index + 1] : nil
            return next is HMPartnerSmallPhotos ? section : nil
        }
    }
}
