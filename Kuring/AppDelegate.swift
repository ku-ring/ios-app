//
//  AppDelegate.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/02/14.
//

import UIKit
import Firebase
import KuringSDK
import AppsFlyerLib

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: Kuring
        Kuring.addDelegate(self, forKey: "AppDelegate")
        
        // MARK: Firebase
        FirebaseApp.configure()
        
        // MARK: Remote notification registration
        registerForRemoteNotification(of: application)
        
        // MARK: AppsFlyerLib
        AppsFlyerLib.shared().appsFlyerDevKey = KuringSDK.Kuring.appsflyerKey
        AppsFlyerLib.shared().appleAppID = KuringSDK.Kuring.appleID
        AppsFlyerLib.shared().isDebug = true
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        AppsFlyerLib.shared().delegate = self

        return true
    }
}
