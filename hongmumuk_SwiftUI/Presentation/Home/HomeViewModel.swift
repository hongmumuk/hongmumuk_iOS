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
                        print("medium")
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
    
    func fetchHMLagePhoto(for items: [HomeItem]) -> HMLagePhotos {
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
}

// {
//  "screenKey": "home",
//  "specVersion": 1,
//  "sections": [
//    {
//      "sectionKey": "today_recommend",
//      "displayOrder": 1,
//      "type": "cards",
//      "props": {
//        "title": "오늘의 추천 맛집"
//        "cardStyle": "large",
//        "cardVariant": "default",
//        "show": ["viewCount", "subTitle", "category", "walkTime"]
//      },
//      "items": [
//        {
//          "id": "43f4346a-967e-44ca-bb01-e8c310adedc0",
//          "mainTitle": "김치찌개로 건물 세운 집",
//          "subTitle": "집밥김치찌개",
//          "heroImageUrl": "https://picsum.photos/900/600?random=101",
//          "detailImageUrls": [
//            "https://picsum.photos/900/600?random=101",
//            "https://picsum.photos/900/600?random=111",
//            "https://picsum.photos/900/600?random=121"
//          ],
//          "cuisineType": "korean",
//          "walkTimeMin": 1,
//          "viewCount": 121,
//          "flags": {}
//        },
//        {
//          "id": "6dc01495-893f-4ba6-b953-be67c02457d1",
//          "mainTitle": "장소만 옮겼어요, 하카타분코",
//          "subTitle": "하카타분코",
//          "heroImageUrl": "https://picsum.photos/900/600?random=102",
//          "detailImageUrls": [
//            "https://picsum.photos/900/600?random=102",
//            "https://picsum.photos/900/600?random=112",
//            "https://picsum.photos/900/600?random=122"
//          ],
//          "cuisineType": "japanese",
//          "walkTimeMin": 1,
//          "viewCount": 122,
//          "flags": {}
//        },
//        {
//          "id": "a5bf47be-c850-49d5-9825-5bc1088756e1",
//          "mainTitle": "요즘 뜨는 홍대 커피바, 틴클",
//          "subTitle": "틴클 커피바",
//          "heroImageUrl": "https://picsum.photos/900/600?random=103",
//          "detailImageUrls": [
//            "https://picsum.photos/900/600?random=103",
//            "https://picsum.photos/900/600?random=113",
//            "https://picsum.photos/900/600?random=123"
//          ],
//          "cuisineType": "cafe",
//          "walkTimeMin": 1,
//          "viewCount": 123,
//          "flags": {}
//        }
//      ]
//    },
//
//    {
//      "sectionKey": "editor_pick",
//      "displayOrder": 2,
//      "type": "cards",
//      "props": {
//        "title": "에디터 추천 5선",
//        "cardStyle": "medium",
//        "cardVariant": "default",
//        "show": ["viewCount", "subTitle"]
//      },
//      "items": [
//        {
//          "id": "179ad39f-4df8-493d-8a11-5f755ee556d8",
//          "mainTitle": "과제할 때 집중 잘 되는 카페",
//          "subTitle": "렉터스 라운지",
//          "heroImageUrl": "https://picsum.photos/600/400?3",
//          "cuisineType": "cafe",
//          "walkTimeMin": 3,
//          "viewCount": 210,
//          "flags": { "editor_pick": true }
//        },
//        {
//          "id": "e5a4a75f-d9cf-4875-8475-9cae9e1e22e8",
//          "mainTitle": "김치찌개로 건물 세운 집",
//          "subTitle": "집밥김치찌개",
//          "heroImageUrl": "https://picsum.photos/600/400?1",
//          "cuisineType": "korean",
//          "walkTimeMin": 5,
//          "viewCount": 120,
//          "flags": { "editor_pick": true, "best": true }
//        }
//      ]
//    },
//
//    {
//      "sectionKey": "new_places",
//      "displayOrder": 3,
//      "type": "cards",
//      "props": {
//        "title": "새로운 장소가 궁금하다면?",
//        "cardStyle": "small",
//        "cardVariant": "tag"
//      },
//      "items": [
//        {
//          "id": "95df83e6-323e-47e3-8bc3-70b551c2d36f",
//          "mainTitle": "요즘 뜨는 홍대 커피바",
//          "subTitle": "틴클",
//          "heroImageUrl": "https://picsum.photos/600/400?4",
//          "cuisineType": "cafe",
//          "walkTimeMin": 4,
//          "viewCount": 40,
//          "flags": { "new": true }
//        }
//      ]
//    },
//
//    {
//      "sectionKey": "category_browse",
//      "displayOrder": 4,
//      "type": "categoryFilterList",
//      "props": {
//        "title": "카테고리별로 볼래요",
//        "cardStyle": "small",
//        "cardVariant": "flag"
//      },
//      "items": [
//        {
//          "id": "00aa0696-789f-4789-a9d8-274ff8baf925",
//          "mainTitle": "국물 한입에 정리됨",
//          "subTitle": "라멘야마",
//          "cuisineType": "japanese",
//          "walkTimeMin": 2,
//          "viewCount": 305,
//          "flags": { "editor_pick": true }
//        }
//      ]
//    }
//  ]
// }
