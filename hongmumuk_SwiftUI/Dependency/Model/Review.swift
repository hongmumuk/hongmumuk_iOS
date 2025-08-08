//
//  Review.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 6/24/25.
//

import Foundation

struct Review: Codable, Equatable, Identifiable {
    var id: Int
    var user: String
    var date: String
    var star: Int
    var content: String
    var isOwner: Bool
    var photoURLs: [String]
    var badge: Badge?
    var rank: Int?
    var restaurantName: String?
    var category: String?

    enum CodingKeys: String, CodingKey {
        case id = "reviewId"
        case user = "name"
        case date = "createdDate"
        case star
        case content
        case photoURLs = "imageUrls"
        case rank
        case isOwner = "mine"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        user = try container.decode(String.self, forKey: .user)
        date = try container.decode(String.self, forKey: .date)

        star = try container.decode(Int.self, forKey: .star)
        content = try container.decode(String.self, forKey: .content)
        photoURLs = try container.decode([String].self, forKey: .photoURLs)
        
        rank = try container.decodeIfPresent(Int.self, forKey: .rank)
        badge = rank.map { Badge.from(rank: $0) }
        
        isOwner = try container.decodeIfPresent(Bool.self, forKey: .isOwner) ?? false
    }
    
    init(
        id: Int,
        user: String,
        date: String,
        star: Int,
        content: String,
        isOwner: Bool,
        photoURLs: [String],
        badge: Badge?,
        rank: Int? = nil,
        restaurantName: String? = nil,
        category: String? = nil
    ) {
        self.id = id
        self.user = user
        self.date = date
        self.star = star
        self.content = content
        self.isOwner = isOwner
        self.photoURLs = photoURLs
        self.badge = badge
        self.rank = rank
        self.restaurantName = restaurantName
        self.category = category
    }
}
