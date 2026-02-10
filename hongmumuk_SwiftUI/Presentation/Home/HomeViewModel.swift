import SwiftUI

@Observable
class HomeViewModel {
    var isLoading = true
    var selectedItem: SelectedItem?
    var sections: [any HM] = []
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
        } catch {
            print("error", error)
        }
    }
    
    private func fetchHMLagePhoto(for items: [HomeItem]) -> HMLagePhotos {
        var result: [HMLagePhoto] = []
        
        for item in items {
            let newItem: HMLagePhoto = .init(
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
}
