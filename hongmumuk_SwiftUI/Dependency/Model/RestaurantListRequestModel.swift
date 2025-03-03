//
//  RestaurantListRequestModel.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/15/25.
//

import Foundation

struct RestaurantListRequestModel: Codable {
    let category: Category
    let page: Int
    let sort: Sort
    
    enum CodingKeys: String, CodingKey {
        case category, page, sort
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(category.rawValue.uppercased(), forKey: .category)
        try container.encode(page, forKey: .page)
        try container.encode(sort.rawValue, forKey: .sort)
    }
}
