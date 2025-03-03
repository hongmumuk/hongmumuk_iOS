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
            "찜 많은 순"
        case .front:
            "정문에서 가까운 순"
        case .back:
            "후문에서 가까운 순"
        case .name:
            "이름순"
        }
    }
}
