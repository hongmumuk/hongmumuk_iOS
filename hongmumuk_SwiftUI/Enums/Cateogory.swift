//
//  Cateogory.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/4/25.
//

import Foundation

enum Category: String, CaseIterable, Codable {
    case all
    case korean
    case chinese
    case japanese
    case western
    case asian
    case fast
    case snack
    case etc
}

extension Category {
    var displayName: String {
        switch self {
        case .all:
            return "전체"
        case .korean:
            return "한식"
        case .chinese:
            return "중식"
        case .japanese:
            return "일식"
        case .western:
            return "양식"
        case .asian:
            return "아시안"
        case .fast:
            return "패·푸"
        case .snack:
            return "분식"
        case .etc:
            return "기타"
        }
    }
}
