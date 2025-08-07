//
//  ProfileSet.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/6/25.
//

import Foundation

enum ProfileSet {
    case info, myReviews, service, privacy, version, lang
}

extension ProfileSet {
    var title: String {
        switch self {
        case .info:
            return "my_info".localized()
        case .myReviews:
            return "내 리뷰"
        case .service:
            return "terms_of_service".localized()
        case .privacy:
            return "privacy_policy".localized()
        case .version:
            return "app_version".localized()
        case .lang:
            return "lang_set".localized()
        }
    }
    
    var isButton: Bool {
        switch self {
        case .info, .myReviews, .service, .privacy, .lang:
            return true
        case .version:
            return false
        }
    }
    
    func showLoingText(_ isUser: Bool) -> Bool {
        if !isUser {
            switch self {
            case .info, .myReviews:
                return true
            default:
                return false
            }
        }
        
        return false
    }
    
    var isShowArrow: Bool {
        switch self {
        case .version:
            return false
        default:
            return true
        }
    }
    
    var urlString: String {
        switch self {
        case .privacy:
            return "https://hongmumuk.notion.site/1ad0ca5d0d2580d6b94adcd47c7ec0da"
            
        case .service:
            return "https://hongmumuk.notion.site/1ae0ca5d0d258062a937f648b35e4b00"
            
        default:
            return ""
        }
    }
}
