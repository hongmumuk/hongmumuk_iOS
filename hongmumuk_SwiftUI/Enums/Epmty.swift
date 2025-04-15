//
//  Epmty.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/3/25.
//

import Foundation

enum Empty {
    case search
    case like
    case likeUnAuth
    case networkError
}

extension Empty {
    var title: String {
        switch self {
        case .search:
            "검색 결과가 없습니다"
        case .like:
            "아직 찜한 가게가 없습니다"
        case .likeUnAuth:
            "로그인이 필요한 기능입니다"
        case .networkError:
            "network_connection_failed".localized()
        }
    }
    
    var subTitle: String {
        switch self {
        case .search:
            "다른 단어로 검색해 보세요"
        case .like:
            "좋아하는 가게에 찜을 누르고 한 번에 모아 보세요"
        case .likeUnAuth:
            "로그인 후 찜한 가게를 모아 보세요"
        case .networkError:
            "check_connection_and_restart_app".localized()
        }
    }
    
    var iconName: String {
        switch self {
        case .networkError: "networkErrorIcon"
        default: "emptyIcon"
        }
    }
}
