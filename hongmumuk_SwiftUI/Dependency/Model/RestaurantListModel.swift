//
//  RestaurantListModel.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/14/25.
//

import Foundation

struct RestaurantListModel: Codable, Identifiable {
    let id: String
    let name: String
    let likes: Int
    let distance: Double
    let category: String

    enum CodingKeys: String, CodingKey {
        case id = "rid"
        case name
        case likes
        case distance
        case category
    }
}
