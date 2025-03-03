//
//  KeychainClient.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/3/25.
//

import Dependencies
import Foundation
import Security

enum KeychainKey: String {
    case accessToken
    case refreshToken
}

struct KeychainClient {
    var setString: @Sendable (_ value: String, _ key: KeychainKey) async -> Void
    var getString: @Sendable (_ key: KeychainKey) async -> String?
    var remove: @Sendable (_ key: KeychainKey) async -> Void
}

extension KeychainClient: DependencyKey {
    static let liveValue = Self(
        setString: { value, key in
            let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key.rawValue,
                kSecValueData: value.data(using: .utf8) ?? Data()
            ]
            
            SecItemDelete(query as CFDictionary)
            SecItemAdd(query as CFDictionary, nil)
        },
        getString: { key in
            let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key.rawValue,
                kSecReturnData: kCFBooleanTrue!,
                kSecMatchLimit: kSecMatchLimitOne
            ]
            
            var dataTypeRef: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
            
            guard status == errSecSuccess, let retrievedData = dataTypeRef as? Data else { return nil }
            
            return String(data: retrievedData, encoding: .utf8)
        },
        remove: { key in
            let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key.rawValue
            ]
            
            SecItemDelete(query as CFDictionary)
        }
    )
}

extension DependencyValues {
    var keychainClient: KeychainClient {
        get { self[KeychainClient.self] }
        set { self[KeychainClient.self] = newValue }
    }
}
