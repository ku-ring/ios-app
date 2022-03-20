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
import GoogleMobileAds

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
        
        // MARK: 인앱광고
        GADMobileAds.sharedInstance().start(completionHandler: nil)


        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // MARK: 온보딩
        self.window?.rootViewController?.showOnboardingViewController()
        
        // MARK: appVersion
        if Kuring.appVersion != Bundle.appVersion {
            Kuring.updateAppVersion(to: Bundle.appVersion)
        }
        
        // MARK: AppsFlyerLib
        AppsFlyerLib.shared().start()
        
        // ATT, App Tracking Transparency
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .denied:
                    Logger.debug("앱트래킹이 거절되었습니다.")
                case .notDetermined:
                    Logger.debug("앱트래킹에 대한 요청이 보류 되었습니다.")
                case .restricted:
                    Logger.debug("앱트래킹에 제약이 걸렸습니다.")
                case .authorized:
                    Logger.debug("앱트래킹이 허용되었습니다.")
                @unknown default:
                    Logger.error("알 수 없는 앱트래킹 상태가 감지되었습니다.")
                    fatalError("Invalid authorization status")
                }
            }
        }
    }
}
