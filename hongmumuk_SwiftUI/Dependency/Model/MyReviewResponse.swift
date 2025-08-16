//
//  MyReviewResponse.swift
//  hongmumuk_SwiftUI
//
//  Created by Assistant on 8/7/25.
//

import Foundation

struct MyReviewResponse: Codable, Equatable {
    let reviewId: Int
    let rname: String
    let uname: String
    let star: Int
    let content: String
    let rank: Int?
    let category: String
    let createdDate: String
    let imageUrls: [String]
    
    // Review 모델로 변환
    func toReview() -> Review {
        return Review(
            id: reviewId,
            user: uname,
            date: createdDate,
            star: star,
            content: content,
            isOwner: true,
            photoURLs: imageUrls,
            badge: rank.map { Badge.from(rank: $0) },
            rank: rank,
            restaurantName: rname,
            category: category
        )
    }
}
