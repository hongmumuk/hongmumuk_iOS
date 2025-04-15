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
            "no_search_results".localized()
        case .like:
            "no_favorite_restaurants".localized()
        case .likeUnAuth:
            "login_required_feature".localized()
        case .networkError:
            "network_connection_failed".localized()
        }
    }
    
    var subTitle: String {
        switch self {
        case .search:
            "try_another_keyword".localized()
        case .like:
            "collect_favorites".localized()
        case .likeUnAuth:
            "login_to_view_favorites".localized()
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
