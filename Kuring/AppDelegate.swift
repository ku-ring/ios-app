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
import AppTrackingTransparency

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
        #if DEBUG
        AppsFlyerLib.shared().isDebug = true
        #endif
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        AppsFlyerLib.shared().delegate = self

        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // MARK: 온보딩
        self.window?.rootViewController?.showOnboardingViewController()
        
        // MARK: appVersion
        if Kuring.appVersion != Bundle.appVersion {
            UserDefaultManager.inAppReviewCount = 0 // reset action count
            Kuring.updateAppVersion(to: Bundle.appVersion)
        }
        
        // MARK: AppsFlyerLib
        AppsFlyerLib.shared().start()
        
        // ATT, App Tracking Transparency
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .denied:
                    Logger.debug("AuthorizationSatus is denied")
                case .notDetermined:
                    Logger.debug("AuthorizationSatus is notDetermined")
                case .restricted:
                    Logger.debug("AuthorizationSatus is restricted")
                case .authorized:
                    Logger.debug("AuthorizationSatus is authorized")
                @unknown default:
                    Logger.error("Invalid authorization status")
                    fatalError("Invalid authorization status")
                }
            }
        }
    }
}
