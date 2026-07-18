import SwiftUI

@Observable
class HomeViewModel {
    var isLoading = true
    var selectedItem: SelectedItem?
    var selectedFitler: Category = .all
    var sections: [any HM] = []
    var displaySections: [any HM] = []
    var filters: [Category] = Category.filterHome()
    
    // id → (placeName, sectionKey) 룩업 - 카드 탭 이벤트에 활용
    private var itemNameMap: [String: String] = [:]
    private var itemSectionMap: [String: String] = [:]
    
    var popupProps: HMPopupProps?
    var popupItems: [HMPopupItem] = []
    
    func getPopupMock() async {
        popupProps = HMPopupProps(
            weekLabel: "weekLabel",
            subtitle: "subtitle",
            title: "title",
            coverUrl: "https://picsum.photos/420/300",
            popupTitle: "popupTitle",
            popupContent: "popupContent"
        )
    }
    
    func getPopup() async {
        if UserDefaultsManager.shared.isViewPopUp {
            return
        }
        
        do {
            let screen = try await SupabaseService.shared.getScreen(for: .popup)
            
            guard let popupSection = screen.sections.first(where: { $0.type == .popup }) else {
                return
            }
            
            let props = popupSection.props
            
            print("popupSection.props", popupSection.props)
            
            guard let weekLabel = props.weekLabel,
                  let subtitle = props.subtitle,
                  let title = props.title,
                  let coverUrl = props.coverUrl,
                  let popupTitle = props.popupTitle,
                  let popupContent = props.popupContent
            else {
                return
            }
            
            popupProps = HMPopupProps(
                weekLabel: weekLabel,
                subtitle: subtitle,
                title: title,
                coverUrl: coverUrl,
                popupTitle: popupTitle,
                popupContent: popupContent
            )
            
            popupItems = popupSection.items.map { item in
                HMPopupItem(
                    id: item.id,
                    image: item.image ?? "",
                    placeName: item.placeName ?? "",
                    category: item.category ?? "",
                    contentTitle: item.contentTitle ?? "",
                    content: item.content ?? "",
                    displayOrder: item.displayOrder ?? 0
                )
            }
        } catch {
            print("error", error)
        }
    }
    
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
                        let item = fetchHMLagePhoto(for: section.items, sectionKey: section.sectionKey)
                        sections.append(item)
                    case .medium:
                        let item = fetchHMMediumPhoto(for: section.items, sectionKey: section.sectionKey)
                        sections.append(item)
                    case .small:
                        let item = fetchTagSmallPhoto(for: section.items, sectionKey: section.sectionKey)
                        sections.append(item)
                    case .none:
                        print("none")
                    }
                    
                case .categoryFilterList:
                    sections.append(HMListFilter())
                    let item = fetchCategorySmallPhoto(for: section.items, sectionKey: section.sectionKey)
                    sections.append(item)
                    
                default:
                    break
                }
            }
            
            displaySections = sections
        } catch {
            print("error", error)
        }
    }
    
    private func fetchHMLagePhoto(for items: [HomeItem], sectionKey: String) -> HMLagePhotos {
        var result: [HMLagePhoto] = []
        
        for item in items {
            itemNameMap[item.id] = item.placeName ?? item.title ?? ""
            itemSectionMap[item.id] = sectionKey
            
            let newItem: HMLagePhoto = .init(
                id: item.id,
                title: item.title ?? "",
                placeName: item.placeName ?? "",
                category: .init(rawValue: item.primaryCategoryKey ?? "") ?? .korean,
                views: item.viewCount ?? 0,
                distance: item.walkTimeMin ?? "0",
                imageUrl: item.image ?? ""
            )
            
            result.append(newItem)
        }
        
        return .init(items: result)
    }
    
    private func fetchHMMediumPhoto(for items: [HomeItem], sectionKey: String) -> HMMediumPhotos {
        var result: [HMMediumPhoto] = []
        
        for item in items {
            itemNameMap[item.id] = item.placeName ?? item.title ?? ""
            itemSectionMap[item.id] = sectionKey
            
            let newItem: HMMediumPhoto = .init(
                id: item.id,
                title: item.title ?? "",
                placeName: item.placeName ?? "",
                views: item.viewCount ?? 0,
                imageUrl: item.image ?? ""
            )
            
            result.append(newItem)
        }
        
        return .init(items: result)
    }
    
    private func fetchTagSmallPhoto(for items: [HomeItem], sectionKey: String) -> HMTagSmallPhotos {
        var result: [HMTagSmallPhoto] = []
        
        for item in items {
            itemNameMap[item.id] = item.placeName ?? item.title ?? ""
            itemSectionMap[item.id] = sectionKey
            
            let newItem: HMTagSmallPhoto = .init(
                id: item.id,
                title: item.title ?? "",
                tags: item.tags ?? [],
                category: .init(rawValue: item.primaryCategoryKey ?? "") ?? .korean,
                distance: item.walkTimeMin ?? "0",
                imageUrl: item.image ?? ""
            )
            
            result.append(newItem)
        }
        
        return .init(items: result)
    }
    
    private func fetchCategorySmallPhoto(for items: [HomeItem], sectionKey: String) -> HMCategorySmallPhotos {
        var result: [HMCategorySmallPhoto] = []
        
        for item in items {
            itemNameMap[item.id] = item.placeName ?? item.title ?? ""
            itemSectionMap[item.id] = sectionKey
            
            let newItem: HMCategorySmallPhoto = .init(
                id: item.id,
                title: item.title ?? "",
                tag: item.tags?.joined(separator: " ") ?? "",
                category: .init(rawValue: item.primaryCategoryKey ?? "") ?? .korean,
                distance: item.walkTimeMin ?? "0",
                imageUrl: item.image ?? ""
            )
            
            result.append(newItem)
        }
        
        return .init(items: result)
    }
    
    func selectItem(for id: String) {
        let placeName = itemNameMap[id] ?? ""
        let section = itemSectionMap[id] ?? ""
        Event.homeCardTapped(placeId: id, placeName: placeName, section: section).send()
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
        Event.homeCategoryFilterSelected(category: category.displayName).send()
    }
    
    private func filteredSections(for category: Category) -> [any HM] {
        sections.compactMap { section in
            guard let categorySection = section as? HMCategorySmallPhotos else {
                return section
            }
            
            let filteredItems = categorySection.items
                .compactMap { $0 as? HMCategorySmallPhoto }
                .filter { $0.category == category }
            
            guard !filteredItems.isEmpty else {
                return HMCategorySmallPhotos(items: [])
            }
            
            return HMCategorySmallPhotos(items: filteredItems)
        }
    }
}
