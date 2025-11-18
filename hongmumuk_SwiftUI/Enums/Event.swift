//
//  Event.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 11/11/25.
//

import Foundation
import Firebase

enum Event {
    
}

extension Event {
    var name: String {
        switch self {
        default: return ""
        }
    }
    
    func send(_ parameters: [String: Any]? = nil) {
        Analytics.logEvent(self.name, parameters: parameters)
    }
}
