//
//  Univ+.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/10/25.
//

import Foundation

extension Univ {
    private var emailDomain: String {
        switch self {
        case .hongik:
            return "g\\.hongik\\.ac\\.kr"
        }
    }
    
    var emailRegex: String {
        switch self {
        case .hongik:
            return "^[A-Za-z0-9]+$"
        }
    }
    
    var passwordRegex: String {
        switch self {
        case .hongik:
            return "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d!@#$%^&*()_+]{8,20}$"
        }
    }
}
