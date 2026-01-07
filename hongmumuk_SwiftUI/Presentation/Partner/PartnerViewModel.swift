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
            
            print("items", items)
            
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
                address: "주소 입니다.",
                imageUrl: item.heroImageUrl ?? "",
                category: .korean
            )
             
            result.append(newItem)
        }
        
        return .init(items: result)
    }
}

// {
//  "screenKey": "partner",
//  "specVersion": 1,
//  "sections": [
//    {
//      "sectionKey": "partner_list",
//      "displayOrder": 1,
//      "type": "categoryFilterList",
//      "props": {
//        "title": "제휴",
//        "cardStyle": "small",
//        "cardVariant": "partner",
//        "show": null
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
//        },
//
//        {
//          "id": "fe18a1de-6f3c-4e18-9851-92517141d5cf",
//          "mainTitle": "제휴 할인 제공 카페",
//          "subTitle": "커피스팟",
//          "heroImageUrl": "https://picsum.photos/600/400?9",
//          "detailImageUrls": [],
//          "cuisineType": null,
//          "walkTimeMin": null,
//          "viewCount": 90,
//          "flags": { "partner": true }
//        },
//        {
//          "id": "92703d8c-1f8d-4d37-ab6d-33fc79d4fdc8",
//          "mainTitle": "몰입감 높은 테마 방탈출",
//          "subTitle": "이스케이프룸 홍대",
//          "heroImageUrl": "https://picsum.photos/600/400?8",
//          "detailImageUrls": [],
//          "cuisineType": null,
//          "walkTimeMin": null,
//          "viewCount": 70,
//          "flags": { "partner": true }
//        },
//
//        {
//          "id": "179ad39f-4df8-493d-8a11-5f755ee556d8",
//          "mainTitle": "과제할 때 집중 잘 되는 카페",
//          "subTitle": "렉터스 라운지",
//          "heroImageUrl": "https://picsum.photos/600/400?3",
//          "detailImageUrls": [],
//          "cuisineType": "cafe",
//          "walkTimeMin": 3,
//          "viewCount": 210,
//          "flags": { "editor_pick": true }
//        },
//
//        {
//          "id": "e5a4a75f-d9cf-4875-8475-9cae9e1e22e8",
//          "mainTitle": "김치찌개로 건물 세운 집",
//          "subTitle": "집밥김치찌개",
//          "heroImageUrl": "https://picsum.photos/600/400?1",
//          "detailImageUrls": [],
//          "cuisineType": "korean",
//          "walkTimeMin": 5,
//          "viewCount": 120,
//          "flags": {
//            "editor_pick": true,
//            "best": true
//          }
//        },
//
//        {
//          "id": "ea28f7d0-e227-410a-987a-5f11795b7417",
//          "mainTitle": "제휴 혜택 안내 (샘플)",
//          "subTitle": "제휴 카페A",
//          "heroImageUrl": "https://picsum.photos/900/600?random=601",
//          "detailImageUrls": [
//            "https://picsum.photos/900/600?random=601",
//            "https://picsum.photos/900/600?random=611"
//          ],
//          "cuisineType": null,
//          "walkTimeMin": 1,
//          "viewCount": 11,
//          "flags": { "partner": true }
//        }
//      ]
//    }
//  ]
// }
