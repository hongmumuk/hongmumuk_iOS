//
//  Cateogory.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/4/25.
//

import Foundation

enum Category: String, CaseIterable, Codable {
    case korean
    case chinese
    case japanese
    case cafe
    case fastfood
    case food
    case life
}

extension Category {
    var displayName: String {
        switch self {
        case .korean: return "한식"
        case .chinese: return "중식"
        case .japanese: return "일식"
        case .cafe: return "카페"
        case .fastfood: return "패스트푸드"
        case .food: return "음식점"
        case .life: return "생활/문화"
        }
    }
}
    