//
//  UserDefaultsClient.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/15/25.
//

import Dependencies
import Foundation

// MARK: - UserDefaultsKey

/// UserDefaults에 저장할 키 정의
enum UserDefaultsKey: String {
    case recentSearchList
    case findPassword
    case signup
    case isNotFirstLaunch
}

struct UserDefaultsClient {
    var setStringArray: @Sendable (_ value: [String], _ key: UserDefaultsKey) async -> Void
    var getStringArray: @Sendable (_ key: UserDefaultsKey) async -> [String]
    
    var setBool: @Sendable (_ value: Bool, _ key: UserDefaultsKey) async -> Void
    var getBool: @Sendable (_ key: UserDefaultsKey) async -> Bool
    
    var setInt: @Sendable (_ value: Int, _ key: UserDefaultsKey) async -> Void
    var getInt: @Sendable (_ key: UserDefaultsKey) async -> Int
    
    var setDouble: @Sendable (_ value: Double, _ key: UserDefaultsKey) async -> Void
    var getDouble: @Sendable (_ key: UserDefaultsKey) async -> Double
    
    var setString: @Sendable (_ value: String, _ key: UserDefaultsKey) async -> Void
    var getString: @Sendable (_ key: UserDefaultsKey) async -> String
    
    var setData: @Sendable (_ value: Data, _ key: UserDefaultsKey) async -> Void
    var getData: @Sendable (_ key: UserDefaultsKey) async -> Data?
    
    var remove: @Sendable (_ key: UserDefaultsKey) async -> Void
}

extension UserDefaultsClient: DependencyKey {
    static let liveValue = Self(
        setStringArray: { value, key in
            UserDefaults.standard.set(value, forKey: key.rawValue)
        },
        getStringArray: { key in
            UserDefaults.standard.stringArray(forKey: key.rawValue) ?? []
        },
        setBool: { value, key in
            UserDefaults.standard.set(value, forKey: key.rawValue)
        },
        getBool: { key in
            UserDefaults.standard.bool(forKey: key.rawValue)
        },
        setInt: { value, key in
            UserDefaults.standard.set(value, forKey: key.rawValue)
        },
        getInt: { key in
            UserDefaults.standard.integer(forKey: key.rawValue)
        },
        setDouble: { value, key in
            UserDefaults.standard.set(value, forKey: key.rawValue)
        },
        getDouble: { key in
            UserDefaults.standard.double(forKey: key.rawValue)
        },
        setString: { value, key in
            UserDefaults.standard.set(value, forKey: key.rawValue)
        },
        getString: { key in
            UserDefaults.standard.string(forKey: key.rawValue) ?? ""
        },
        setData: { value, key in
            UserDefaults.standard.set(value, forKey: key.rawValue)
        },
        getData: { key in
            UserDefaults.standard.data(forKey: key.rawValue)
        },
        remove: { key in
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
    )
}

extension DependencyValues {
    var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}
