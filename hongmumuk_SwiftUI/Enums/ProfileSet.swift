//
//  ProfileSet.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/6/25.
//

import Foundation

enum ProfileSet {
    case info, service, privacy, version
}

extension ProfileSet {
    var title: String {
        switch self {
        case .info:
            return "내 정보"
        case .service:
            return "서비스 이용약관"
        case .privacy:
            return "개인정보 처리방침"
        case .version:
            return "버전 정보"
        }
    }
    
    var isButton: Bool {
        switch self {
        case .info, .service, .privacy:
            return true
        case .version:
            return false
        }
    }
    
    func showLoingText(_ isUser: Bool) -> Bool {
        if !isUser {
            switch self {
            case .info:
                return true
            default:
                return false
            }
        }
        
        return false
    }
    
    var urlString: String {
        switch self {
        case .privacy:
            return "https://akaseoyoung.notion.site/1ac630c6c92f80629108c2d5f946008d"
            
        case .service:
            return "https://akaseoyoung.notion.site/1ac630c6c92f806b9dd7fd918b0356bb"
            
        default:
            return ""
        }
    }
}
