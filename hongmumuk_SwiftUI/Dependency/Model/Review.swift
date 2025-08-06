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
        
        // mine 필드에서 isOwner 설정
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
        rank: Int? = nil
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
    }
}

extension Review {
    /// Mock 리뷰 데이터 생성을 위한 static 메서드
    static func mockReviews() -> [Review] {
        return [
            Review(
                id: 1,
                user: "세영이",
                date: "2025-06-20",
                star: 4,
                content: "제육볶음 정말 맛있어요! 재방문 의사 100%",
                isOwner: false,
                photoURLs: [
                    "https://example.com/photo1.jpg",
                    "https://example.com/photo2.jpg",
                    "https://example.com/photo3.jpg"
                ],
                badge: .newbie
            ),
            Review(
                id: 2,
                user: "도연",
                date: "2025-06-21",
                star: 5,
                content: "가성비 최고예요. 반찬 구성도 알차고 사장님도 친절해요.",
                isOwner: false,
                photoURLs: [],
                badge: .explorer
            ),
            Review(
                id: 3,
                user: "맛집헌터",
                date: "2025-06-22",
                star: 4,
                content: "맛도 좋고 양도 푸짐했어요. 점심시간엔 줄이 길 수 있어요.",
                isOwner: false,
                photoURLs: ["https://example.com/photo4.jpg"],
                badge: .foodie
            ),
            Review(
                id: 4,
                user: "식당주인",
                date: "2025-06-23",
                star: 5,
                content: "사장입니다 :) 항상 좋은 재료로 정성껏 만들고 있어요!",
                isOwner: true,
                photoURLs: [],
                badge: .master
            ),
            Review(
                id: 5,
                user: "카메라장인",
                date: "2025-06-24",
                star: 5,
                content: "비주얼이 정말 예술이에요! 사진 맛집 인정합니다.",
                isOwner: false,
                photoURLs: [
                    "https://example.com/photo5_1.jpg",
                    "https://example.com/photo5_2.jpg",
                    "https://example.com/photo5_3.jpg",
                    "https://example.com/photo5_4.jpg"
                ],
                badge: .newbie
            )
        ] + (6 ... 30).map {
            Review(
                id: $0,
                user: "유저\($0)",
                date: "2025-06-\(String(format: "%02d", ($0 % 30) + 1))",
                star: Int.random(in: 3 ... 5),
                content: "리뷰 내용 \($0): 이 집 괜찮아요~",
                isOwner: false,
                photoURLs: $0 % 3 == 0 ? ["https://example.com/photo\($0).jpg"] : [],
                badge: $0 % 5 == 0 ? .explorer : .newbie
            )
        }
    }
}
