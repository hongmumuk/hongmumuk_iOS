import SwiftUI

@Observable
class HomeViewModel {
    var isLoading = true
    var sections: [any HM] = []
    
    func getSections() async {
        if !sections.isEmpty {
            sections = []
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
                        print("small")
                    case .none:
                        print("none")
                    }
                case .categoryFilterList:
                    print("categoryFilterList")
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
                title: item.mainTitle,
                subtitle: item.subTitle ?? "",
                category: .init(rawValue: item.cuisineType!) ?? .korean,
                views: item.viewCount ?? 0,
                distance: item.walkTimeMin ?? 0,
                imageUrl: item.heroImageUrl ?? ""
            )
             
            result.append(newItem)
        }
        
        return .init(items: result)
    }
    
    private func fetchHMMediumPhoto(for items: [HomeItem]) -> HMMediumPhotos {
        var result: [HMMediumPhoto] = []
        
        for item in items {
            let newItem: HMMediumPhoto = .init(
                title: item.mainTitle,
                subtitle: item.subTitle ?? "",
                views: item.viewCount ?? 0,
                imageUrl: item.heroImageUrl ?? ""
            )
             
            result.append(newItem)
        }
        
        return .init(items: result)
    }
}
