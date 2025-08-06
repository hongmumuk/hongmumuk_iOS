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
        case reviews = "reviewDto"
    }
    
    init(reviewCount: Int, reviews: [Review]) {
        self.reviewCount = reviewCount
        self.reviews = reviews
    }
}
