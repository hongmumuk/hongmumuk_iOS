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
        case .recent: return "최신순"
        case .high: return "별점 높은 순"
        case .low: return "별점 낮은 순"
        }
    }
}
