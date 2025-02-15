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
}
