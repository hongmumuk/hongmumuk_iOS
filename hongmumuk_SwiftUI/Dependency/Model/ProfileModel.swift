//
//  ProfileModel.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/7/25.
//

import Foundation

struct ProfileModel: Codable, Equatable {
    let nickName: String
    let email: String
}

extension ProfileModel {
    static func mock() -> Self {
        return .init(nickName: "", email: "")
    }
}
