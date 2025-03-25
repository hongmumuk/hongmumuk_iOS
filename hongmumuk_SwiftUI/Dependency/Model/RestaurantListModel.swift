//
//  RestaurantListModel.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/14/25.
//

import Foundation

struct RestaurantListModel: Equatable, Codable, Identifiable {
    var id: Int
    var name: String
    var likes: Int
    var frontDistance: Double
    var backDistance: Double
    var category: Category
    var imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case likes
        case frontDistance = "front"
        case backDistance = "back"
        case category
        case imageUrl
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        likes = try container.decode(Int.self, forKey: .likes)
        frontDistance = try container.decode(Double.self, forKey: .frontDistance)
        backDistance = try container.decode(Double.self, forKey: .backDistance)
        imageUrl = try container.decode(String?.self, forKey: .imageUrl)
        
        // category 값을 디코딩 후, 소문자로 변환하여 Category 열거형으로 변환
        let categoryRaw = try container.decode(String.self, forKey: .category)
        category = Category(rawValue: categoryRaw.lowercased()) ?? .all
    }
    
    init(
        id: Int,
        name: String,
        likes: Int,
        frontDistance: Double,
        backDistance: Double,
        category: Category,
        imageUrl: String?
    ) {
        self.id = id
        self.name = name
        self.likes = likes
        self.frontDistance = frontDistance
        self.backDistance = backDistance
        self.category = category
        self.imageUrl = imageUrl
    }
}

extension RestaurantListModel {
    /// 더미 데이터 생성을 위한 mock 함수
    static func mock() -> [RestaurantListModel] {
        let restaurantNames = [
            "발바리네",
            "연남서가",
            "정돈",
            "카덴",
            "온오프",
            "만땅젤라또",
            "연남살롱",
            "연우마라탕",
            "오사카부루",
            "모터시티",
            "연남토마",
            "키친가봉",
            "포포브라더스",
            "카메야",
            "히메시야"
        ]
        
        return (0 ..< 100).map { _ in
            RestaurantListModel(
                id: UUID().hashValue,
                name: restaurantNames.randomElement() ?? "The Restaurant",
                likes: Int.random(in: 1 ... 100),
                frontDistance: Double.random(in: 1 ... 500),
                backDistance: Double.random(in: 1 ... 500),
                category: Category.allCases.randomElement()!,
                imageUrl: "https://hongmumuk.s3.ap-northeast-2.amazonaws.com/da2f8019-ffcd-4d63-9167-c4d0c5748508.webp"
            )
        }
    }
}
