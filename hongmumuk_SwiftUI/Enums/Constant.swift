//
//  Constant.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/10/25.
//

import Foundation

enum Constant {
    // config 파일에 정의한 key
    enum Keys {
        enum Plist {
            static let baseUrl = "BASE_URL"
            static let appsFlyerDevKey = "DEV_KEY"
            static let appleAppID = "APP_ID"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    // config 파일에 정의한 value
    static let baseUrl: URL = {
        guard let baseUrlString = Constant.infoDictionary[Keys.Plist.baseUrl] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        
        guard let url = URL(string: baseUrlString) else {
            fatalError("Root URL is invalid")
        }
        
        return url
    }()
    
    static let appsFlyerDevKey: String = {
        guard let key = Constant.infoDictionary[Keys.Plist.appsFlyerDevKey] as? String else {
            fatalError("AppsFlyer Dev Key not set in plist")
        }
        return key
    }()
    
    static let appleAppID: String = {
        guard let id = Constant.infoDictionary[Keys.Plist.appleAppID] as? String else {
            fatalError("Apple App ID not set in plist")
        }
        return id
    }()
}
