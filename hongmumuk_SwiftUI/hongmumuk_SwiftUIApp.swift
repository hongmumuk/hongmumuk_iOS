//
//  hongmumuk_SwiftUIApp.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 1/19/25.
//

import AppTrackingTransparency
import SwiftUI

@main
struct Hongmumuk_SwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        requestTrackingAuthorizationIfNeeded()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    private func requestTrackingAuthorizationIfNeeded() {
        if #available(iOS 14, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    print("ATT Authorization status: \(status.rawValue)")
                }
            }
        }
    }
}
