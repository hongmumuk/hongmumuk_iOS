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
    var category: String
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
        likes = try container.decode(Int.self, forKey: .likes)
        frontDistance = try container.decode(Double.self, forKey: .frontDistance)
        backDistance = try container.decode(Double.self, forKey: .backDistance)
        longitude = try container.decode(Double.self, forKey: .longitude)
        latitude = try container.decode(Double.self, forKey: .latitude)
        
        let categoryRaw = try container.decode(String.self, forKey: .category)
        let categoryEnum = Category(rawValue: categoryRaw.lowercased()) ?? .all
        category = categoryEnum.displayName
        
        address = try container.decode(String.self, forKey: .address)
        hasLiked = try container.decode(Bool.self, forKey: .hasLiked)
        blogs = try container.decode([Blog].self, forKey: .blogs)
        naverLink = try container.decode(String.self, forKey: .naverLink)
        kakaoLink = try container.decode(String.self, forKey: .kakaoLink)
    }
    
    // 직접 초기화할 수 있는 이니셜라이저 (테스트나 다른 용도에 사용)
    init(id: String,
         name: String,
         likes: Int,
         frontDistance: Double,
         backDistance: Double,
         longitude: Double,
         latitude: Double,
         category: String,
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

extension RestaurantDetail {
    static func mock() -> Self {
        let blogs: [Blog] = [
            Blog(
                id: 000,
                url: "https://blog.naver.com/mongandmong/223659156927",
                title: "홍대 발바리네 가성비 최고 제육 맛집 홍대 밥집",
                subtitle: "제육볶음정식 등 다양한 메뉴 사진과 상세한 후기",
                date: "2025-02-20",
                owner: "mongandmong"
            ),
            Blog(
                id: 000,
                url: "https://blog.naver.com/tenny16/223251501793",
                title: "홍대 발바리네 8,000원의 가성비 직화 제육볶음 백반 맛집",
                subtitle: "직화로 조리한 제육볶음 백반의 사진과 식당 내부 분위기 소개",
                date: "2025-01-15",
                owner: "tenny16"
            ),
            Blog(
                id: 000,
                url: "https://blog.naver.com/jjong1034_/223318725721",
                title: "홍대 밥집 투어 홍대발바리네 제육볶음정식",
                subtitle: "제육볶음정식의 사진과 메뉴판 사진 제공",
                date: "2025-01-25",
                owner: "jjong1034_"
            ),
            Blog(
                id: 000,
                url: "https://blog.naver.com/vnq23/222078025121",
                title: "홍대입구역 가성비 최고 한식 맛집 발바리네",
                subtitle: "제육볶음, 찌개, 계란 후라이, 스팸 등 다양한 메뉴와 밑반찬 사진",
                date: "2024-12-10",
                owner: "vnq23"
            )
        ]
        
        return RestaurantDetail(
            id: "234",
            name: "발바리네",
            likes: 300,
            frontDistance: 300,
            backDistance: 200,
            longitude: 126.92767017449005,
            latitude: 37.55328226741065,
            category: "한식",
            address: "서울 마포구 와우산로 51-6",
            hasLiked: true,
            blogs: blogs,
            naverLink: "",
            kakaoLink: ""
        )
    }
}
