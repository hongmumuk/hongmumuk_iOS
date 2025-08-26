//
//  Badge.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 7/19/25.
//

import SwiftUI

enum Badge: String, CaseIterable, Identifiable, Codable {
    case newbie // 리뷰 새내기
    case explorer // 홍대 맛잘알
    case foodie // 홍대 미식가
    case master // 맛집 최강자

    var id: String { rawValue }

    var ableIconName: String {
        "\(rawValue)_abled"
    }

    var disableIconName: String {
        "\(rawValue)_disabled"
    }

    // displayName removed in favor of localizedName
    
    // rank 값으로 Badge 생성
    static func from(rank: Int) -> Badge {
        switch rank {
        case 1 ... 5: return .newbie
        case 6 ... 10: return .explorer
        case 11 ... 29: return .foodie
        case 30...: return .master
        default: return .newbie
        }
    }
}

extension Badge {
    var localizedName: String {
        switch self {
        case .newbie:
            return "badge_review_rookie".localized()
        case .explorer:
            return "badge_hongdae_foodie".localized()
        case .foodie:
            return "badge_hongdae_gourmet".localized()
        case .master:
            return "badge_food_champion".localized()
        }
    }
}
