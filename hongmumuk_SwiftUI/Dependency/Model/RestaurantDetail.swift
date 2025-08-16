//
//  RestaurantDetail.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/22/25.
//

import Foundation

struct RestaurantDetail: Codable, Identifiable, Equatable {
    var id: String
    var name: String
    var likes: Int
    var frontDistance: Double
    var backDistance: Double
    var longitude: Double
    var latitude: Double
    var category: Category
    var address: String
    var hasLiked: Bool
    var blogs: [Blog]
    var naverLink: String
    var kakaoLink: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case likes
        case frontDistance = "front"
        case backDistance = "back"
        case longitude
        case latitude
        case category
        case address
        case hasLiked
        case blogs
        case naverLink
        case kakaoLink
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        likes = try container.decodeIfPresent(Int.self, forKey: .likes) ?? 0
        frontDistance = try container.decode(Double.self, forKey: .frontDistance)
        backDistance = try container.decode(Double.self, forKey: .backDistance)
        longitude = try container.decode(Double.self, forKey: .longitude)
        latitude = try container.decode(Double.self, forKey: .latitude)
        
        let categoryRaw = try container.decode(String.self, forKey: .category)
        category = Category(rawValue: categoryRaw.lowercased()) ?? .all
        
        address = try container.decode(String.self, forKey: .address)
        hasLiked = try container.decode(Bool.self, forKey: .hasLiked)
        blogs = try container.decode([Blog].self, forKey: .blogs)
        naverLink = try container.decode(String.self, forKey: .naverLink)
        kakaoLink = try container.decode(String.self, forKey: .kakaoLink)
    }
    
    // 기본 초기화 (빈 상태)
    init() {
        id = ""
        name = ""
        likes = 0
        frontDistance = 0
        backDistance = 0
        longitude = 0
        latitude = 0
        category = .all
        address = ""
        hasLiked = false
        blogs = []
        naverLink = ""
        kakaoLink = ""
    }
    
    // 직접 초기화할 수 있는 이니셜라이저 (테스트나 다른 용도에 사용)
    init(id: String,
         name: String,
         likes: Int,
         frontDistance: Double,
         backDistance: Double,
         longitude: Double,
         latitude: Double,
         category: Category,
         address: String,
         hasLiked: Bool,
         blogs: [Blog],
         naverLink: String,
         kakaoLink: String)
    {
        self.id = id
        self.name = name
        self.likes = likes
        self.frontDistance = frontDistance
        self.backDistance = backDistance
        self.longitude = longitude
        self.latitude = latitude
        self.category = category
        self.address = address
        self.hasLiked = hasLiked
        self.blogs = blogs
        self.naverLink = naverLink
        self.kakaoLink = kakaoLink
    }
}
