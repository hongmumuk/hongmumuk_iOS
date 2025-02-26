//
//  ValidationClient.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/10/25.
//

import Dependencies

struct ValidationClient {
    var validateEmail: (_ email: String) -> Bool
    var validatePassword: (_ password: String) -> Bool
}

extension ValidationClient: DependencyKey {
    static func live(univType: Univ) -> Self {
        return .init(
            validateEmail: { email in
                let isValidLength = (3 ... 20).contains(email.count)
                let matchesRegex = email.range(of: univType.emailRegex, options: .regularExpression) != nil
                return isValidLength && matchesRegex
            },
            validatePassword: { password in
                let isValidLength = (8 ... 20).contains(password.count)
                let matchesRegex = password.range(of: univType.passwordRegex, options: .regularExpression) != nil
                return isValidLength && matchesRegex
            }
        )
    }
    
    static var liveValue = ValidationClient.live(univType: .hongik)
}

extension DependencyValues {
    var validationClient: ValidationClient {
        get { self[ValidationClient.self] }
        set { self[ValidationClient.self] = newValue }
    }
}
