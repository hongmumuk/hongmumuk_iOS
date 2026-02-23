import SwiftUI

@Observable
class HomeViewModel {
    var isLoading = true
    var selectedItem: SelectedItem?
    var selectedFitler: Category = .all
    var sections: [any HM] = []
    var displaySections: [any HM] = []
    var filters: [Category] = Category.filterHome()
    
    func getSections() async {
        if !sections.isEmpty {
            return
        }
        
        do {
            let items = try await SupabaseService.shared.getScreen(for: .home)
            
            for section in items.sections {
                if let title = section.props.title {
                    let item = HMLTitle(title: title)
                    sections.append(item)
                }
                
                switch section.type {
                case .cards:
                    switch section.props.cardStyle {
                    case .large:
                        let item = fetchHMLagePhoto(for: section.items)
                        sections.append(item)
                    case .medium:
                        let item = fetchHMMediumPhoto(for: section.items)
                        sections.append(item)
                    case .small:
                        let item = fetchTagSmallPhoto(for: section.items)
                        sections.append(item)
                    case .none:
                        print("none")
                    }
                    
                case .categoryFilterList:
                    sections.append(HMListFilter())
                    
                    let item = fetchCategorySmallPhoto(for: section.items)
                    sections.append(item)
                }
            }
            
            displaySections = sections
        } catch {
            print("error", error)
        }
    }
    
    private func fetchHMLagePhoto(for items: [HomeItem]) -> HMLagePhotos {
        var result: [HMLagePhoto] = []
        
        for item in items {
            let newItem: HMLagePhoto = .init(
                id: item.id,
                title: item.title ?? "",
                subtitle: item.subtitle ?? "",
                category: .init(rawValue: item.primaryCategoryKey ?? "") ?? .korean,
                views: item.viewCount ?? 0,
                distance: item.walkTimeMin ?? 0,
                imageUrl: item.image ?? ""
            )
            
            result.append(newItem)
        }
        
        return .init(items: result)
    }
    
    private func fetchHMMediumPhoto(for items: [HomeItem]) -> HMMediumPhotos {
        var result: [HMMediumPhoto] = []

        for item in items {
            let newItem: HMMediumPhoto = .init(
                id: item.id,
                title: item.title ?? "",
                subtitle: item.subtitle ?? "",
                views: item.viewCount ?? 0,
                imageUrl: item.image ?? ""
            )

            result.append(newItem)
        }

        return .init(items: result)
    }
    
    private func fetchTagSmallPhoto(for items: [HomeItem]) -> HMTagSmallPhotos {
        var result: [HMTagSmallPhoto] = []

        for item in items {
            let newItem: HMTagSmallPhoto = .init(
                id: item.id,
                title: item.title ?? "",
                tags: item.tags ?? [],
                category: .init(rawValue: item.primaryCategoryKey ?? "") ?? .korean,
                distance: item.walkTimeMin ?? 0,
                imageUrl: item.image ?? ""
            )

            result.append(newItem)
        }

        return .init(items: result)
    }
    
    private func fetchCategorySmallPhoto(for items: [HomeItem]) -> HMCategorySmallPhotos {
        var result: [HMCategorySmallPhoto] = []

        for item in items {
            let newItem: HMCategorySmallPhoto = .init(
                id: item.id,
                title: item.title ?? "",
                tag: item.tags?.joined(separator: " ") ?? "",
                category: .init(rawValue: item.primaryCategoryKey ?? "") ?? .korean,
                distance: item.walkTimeMin ?? 0,
                imageUrl: item.image ?? ""
            )

            result.append(newItem)
        }

        return .init(items: result)
    }
    
    func selectItem(for id: String) {
        selectedItem = .init(id: id)
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
            // categorySmallPhoto가 아니면 그대로 유지
            guard let categorySection = section as? HMCategorySmallPhotos else {
                return section
            }

            // category 기준 필터링
            let filteredItems = categorySection.items
                .compactMap { $0 as? HMCategorySmallPhoto }
                .filter { $0.category == category }

            // 필터 결과가 없으면 섹션 제거
            guard !filteredItems.isEmpty else {
                return nil
            }

            // 필터된 categorySmallPhoto 섹션만 교체
            return HMCategorySmallPhotos(items: filteredItems)
        }
    }
}
