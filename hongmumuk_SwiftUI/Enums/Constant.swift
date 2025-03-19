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
}
