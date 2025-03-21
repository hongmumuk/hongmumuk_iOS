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
            return "https://hongmumuk.notion.site/1ad0ca5d0d2580d6b94adcd47c7ec0da"
            
        case .service:
            return "https://hongmumuk.notion.site/1ae0ca5d0d258062a937f648b35e4b00"
            
        default:
            return ""
        }
    }
}
