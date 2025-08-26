//
//  ReviewSortOption.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 6/24/25.
//

import Foundation

enum ReviewSortOption: String, CaseIterable, Equatable {
    case recent
    case high
    case low

    var displayName: String {
        switch self {
        case .recent: return "sort_by_newest".localized()
        case .high: return "sort_by_highest_rating".localized()
        case .low: return "sort_by_lowest_rating".localized()
        }
    }
}
