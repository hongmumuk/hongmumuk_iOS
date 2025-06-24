//
//  ReviewSortOption.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 6/24/25.
//

import Foundation

enum ReviewSortOption: String, CaseIterable, Equatable {
    case newest
    case highestRating
    case lowestRating

    var displayName: String {
        switch self {
        case .newest: return "최신순"
        case .highestRating: return "별점 높은 순"
        case .lowestRating: return "별점 낮은 순"
        }
    }
}
