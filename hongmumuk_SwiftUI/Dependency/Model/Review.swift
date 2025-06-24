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
    var visitCount: Int
    var star: Double
    var content: String
    var isOwner: Bool
    var photoURLs: [String]
    var badge: String

    enum CodingKeys: String, CodingKey {
        case id, user, date, visitCount, star, content, isOwner
        case photoURLs = "photos"
        case badge
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        user = try container.decode(String.self, forKey: .user)
        date = try container.decode(String.self, forKey: .date)
        visitCount = try container.decode(Int.self, forKey: .visitCount)
        star = try container.decode(Double.self, forKey: .star)
        content = try container.decode(String.self, forKey: .content)
        isOwner = try container.decode(Bool.self, forKey: .isOwner)
        photoURLs = try container.decode([String].self, forKey: .photoURLs)
        badge = try container.decode(String.self, forKey: .badge)
    }

    init(
        id: Int,
        user: String,
        date: String,
        visitCount: Int,
        star: Double,
        content: String,
        isOwner: Bool,
        photoURLs: [String],
        badge: String
    ) {
        self.id = id
        self.user = user
        self.date = date
        self.visitCount = visitCount
        self.star = star
        self.content = content
        self.isOwner = isOwner
        self.photoURLs = photoURLs
        self.badge = badge
    }
}
