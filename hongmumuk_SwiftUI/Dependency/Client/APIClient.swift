//
//  APIClient.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/24/25.
//

import Alamofire
import Foundation

enum APIClient {
    static let authorized: Session = {
        let interceptor = NetworkInterceptor()
        return Session(interceptor: interceptor)
    }()
    
    static let plain: Session = {
        return Session()
    }()
}
