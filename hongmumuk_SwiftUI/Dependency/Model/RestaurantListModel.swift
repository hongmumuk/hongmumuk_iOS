//
//  RestaurantListModel.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/14/25.
//

import Foundation

struct RestaurantListModel: Equatable, Codable, Identifiable {
    var id: String
    var name: String
    var likes: Int
    let distance: Double
    let category: String

    enum CodingKeys: String, CodingKey {
        case id = "rid"
        case name
        case likes
        case distance
        case category
    }
    
    static func mock() -> [Self] {
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
        
        return Array(
            repeating: RestaurantListModel(
                id: "1",
                name: restaurantNames.randomElement() ?? "The Restaurant",
                likes: 300,
                distance: 400,
                category: Category.korean.displayName
            ),
            count: 100
        )
        .map { old in
            var new = old
            new.likes = (1 ... 100).randomElement() ?? 10
            new.id = UUID().uuidString
            new.name = restaurantNames.randomElement() ?? "The Restaurant"
            return new
        }
    }
}
