//
//  ReviewResponse.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 7/20/25.
//

import Foundation

struct ReviewResponse: Codable, Equatable {
    let reviewCount: Int
    let reviews: [Review]
    
    enum CodingKeys: String, CodingKey {
        case reviewCount
        case reviews
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        reviewCount = try container.decode(Int.self, forKey: .reviewCount)
        reviews = try container.decode([Review].self, forKey: .reviews)
    }
    
    init(reviewCount: Int, reviews: [Review]) {
        self.reviewCount = reviewCount
        self.reviews = reviews
    }
}
