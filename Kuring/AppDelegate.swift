//
//  AppDelegate.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/02/14.
//

import UIKit
import Firebase
import KuringSDK

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
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let userInfo: [String: Any] = [
            "category": "bachelor",
            "articleId": "5b49f62",
            "subject": "[인공지능] 2022학년도 1학기 인공지능(AI) 온라인 모듈형 교육과정 신청 안내",
            "baseUrl": "",
            "postedDate": "20220128"
        ]
        openBanner(with: userInfo)
    }
}
