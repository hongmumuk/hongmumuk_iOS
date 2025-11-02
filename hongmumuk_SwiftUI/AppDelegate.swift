//
//  AppDelegate.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 6/1/25.
//

import AppsFlyerLib
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        AppsFlyerLib.shared().appsFlyerDevKey = Constant.appsFlyerDevKey
        AppsFlyerLib.shared().appleAppID = Constant.appleAppID
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().start()
        
        return true
    }
    
    // Handle Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        return true
    }
    
    // Handle Custom URL Scheme
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool
    {
        AppsFlyerLib.shared().handleOpen(url, options: options)
        return true
    }
}

extension AppDelegate: AppsFlyerLibDelegate {
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable: Any]) {
        print("[AppsFlyer] Conversion Data: \(conversionInfo)")
    }
    
    func onConversionDataFail(_ error: Error) {
        print("[AppsFlyer] Conversion Data Fail: \(error.localizedDescription)")
    }
    
    func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
        NotificationCenter.default.post(
            name: .didReceiveDeepLink,
            object: nil,
            userInfo: attributionData
        )
    }
    
    func onAppOpenAttributionFailure(_ error: Error) {
        print("[AppsFlyer] Deep link attribution failed: \(error.localizedDescription)")
    }
}

extension Notification.Name {
    static let didReceiveDeepLink = Notification.Name("didReceiveDeepLink")
}
