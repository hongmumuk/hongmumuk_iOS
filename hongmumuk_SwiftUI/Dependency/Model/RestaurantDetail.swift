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
    
    static func mock() -> Self {
        let blogs: [Blog] = [
            Blog(
                url: "https://blog.naver.com/mongandmong/223659156927",
                title: "홍대 발바리네 가성비 최고 제육 맛집 홍대 밥집",
                subtitle: "제육볶음정식 등 다양한 메뉴 사진과 상세한 후기",
                date: "2025-02-20",
                owner: "mongandmong"
            ),
            Blog(
                url: "https://blog.naver.com/tenny16/223251501793",
                title: "홍대 발바리네 8,000원의 가성비 직화 제육볶음 백반 맛집",
                subtitle: "직화로 조리한 제육볶음 백반의 사진과 식당 내부 분위기 소개",
                date: "2025-01-15",
                owner: "tenny16"
            ),
            Blog(
                url: "https://blog.naver.com/jjong1034_/223318725721",
                title: "홍대 밥집 투어 홍대발바리네 제육볶음정식",
                subtitle: "제육볶음정식의 사진과 메뉴판 사진 제공",
                date: "2025-01-25",
                owner: "jjong1034_"
            ),
            Blog(
                url: "https://blog.naver.com/vnq23/222078025121",
                title: "홍대입구역 가성비 최고 한식 맛집 발바리네",
                subtitle: "제육볶음, 찌개, 계란 후라이, 스팸 등 다양한 메뉴와 밑반찬 사진",
                date: "2024-12-10",
                owner: "vnq23"
            )
        ]

        return .init(
            id: "234",
            name: "발바리네",
            likes: 300,
            frontDistance: 300,
            backDistance: 200,
            longitude: 126.92767017449005,
            latitude: 37.55328226741065,
            category: .korean,
            address: "서울 마포구 와우산로 51-6",
            hasLiked: true,
            blogs: blogs
        )
    }
}
