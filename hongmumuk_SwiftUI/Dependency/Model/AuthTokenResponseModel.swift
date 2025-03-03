//
//  AuthTokenResponseModel.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/3/25.
//

import Foundation

struct AuthTokenResponseModel: Codable {
    let accessToken: String
    let refreshToken: String
}
