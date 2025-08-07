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
            return "korean".localized()
        case .chinese:
            return "chinese".localized()
        case .japanese:
            return "japanese".localized()
        case .western:
            return "western".localized()
        case .asian:
            return "asian".localized()
        case .fast:
            return "fastfood".localized()
        case .snack:
            return "snack".localized()
        case .etc:
            return "etc".localized()
        }
    }


}
