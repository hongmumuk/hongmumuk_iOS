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
    var star: Int
    var content: String
    var isOwner: Bool
    var photoURLs: [String]
    var badge: Badge?
    var rank: Int?

    enum CodingKeys: String, CodingKey {
        case id = "reviewId"
        case user = "name"
        case date = "createdDate"
        case visitCount = "reviewCount"
        case star
        case content
        case photoURLs = "images"
        case rank
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        user = try container.decode(String.self, forKey: .user)
        date = try container.decode(String.self, forKey: .date)
        visitCount = try container.decodeIfPresent(Int.self, forKey: .visitCount) ?? 0
        star = try container.decode(Int.self, forKey: .star)
        content = try container.decode(String.self, forKey: .content)
        photoURLs = try container.decode([String].self, forKey: .photoURLs)
        
        // rank 디코딩 및 badge 결정
        rank = try container.decodeIfPresent(Int.self, forKey: .rank)
        badge = rank.map { rankValue -> Badge in
            switch rankValue {
            case 1 ... 5: return .newbie // 1~5위: 리뷰 새내기
            case 6 ... 10: return .explorer // 6~10위: 홍대 맛잘알
            case 11 ... 29: return .foodie // 11~29위: 홍대 미식가
            case 30...: return .master // 30위 이상: 맛집 최강자
            default: return .newbie // 기본값: 리뷰 새내기
            }
        }
        
        // isOwner는 API에서 제공하지 않으므로 기본값 false
        isOwner = false
    }
    
    init(
        id: Int,
        user: String,
        date: String,
        visitCount: Int,
        star: Int,
        content: String,
        isOwner: Bool,
        photoURLs: [String],
        badge: Badge?,
        rank: Int? = nil
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
        self.rank = rank
    }
}
