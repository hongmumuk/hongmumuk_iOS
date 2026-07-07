//
//  UserDefaults.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/7/26.
//
import SwiftUI

enum UserDefaultsKeys {
    static let isViewPopUp = "isViewPopUp"
}

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let defaults = UserDefaults.standard

    var isViewPopUp: Bool {
        get {
            defaults.bool(forKey: UserDefaultsKeys.isViewPopUp)
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.isViewPopUp)
        }
    }
}
