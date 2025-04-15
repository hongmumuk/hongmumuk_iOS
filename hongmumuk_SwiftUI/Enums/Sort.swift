//
//  Sort.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/15/25.
//

import Foundation

enum Sort: String, Codable, CaseIterable {
    case likes
    case front
    case back
    case name
}

extension Sort {
    var displayName: String {
        switch self {
        case .likes:
            "sort_by_likes".localized()
        case .front:
            "sort_by_front_gate".localized()
        case .back:
            "sort_by_back_gate".localized()
        case .name:
            "sort_by_name".localized()
        }
    }
}
