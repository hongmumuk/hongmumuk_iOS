//
//  LoginError.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/10/25.
//

import Foundation

public enum LoginError: String, Error {
    case userNotFound = "BAD400_1"
    case invalidCredentials = "BAD400_2"
    case alreadyExists = "CONFLICT409_1"
    case noVerificationRecord = "BAD400"
    case expiredCode = "BAD400_3"
    case invalidCode = "BAD400_4"
    case unknown
}
