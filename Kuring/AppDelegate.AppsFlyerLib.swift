//
//  AppDelegate.AppsFlyerLib.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/02/23.
//

import UIKit
import AppsFlyerLib
import AppTrackingTransparency

extension AppDelegate: AppsFlyerLibDelegate {
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        
    }
    
    func onConversionDataFail(_ error: Error) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start()
        
        // ATT, App Tracking Transparency
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .denied:
                    print("AuthorizationSatus is denied")
                case .notDetermined:
                    print("AuthorizationSatus is notDetermined")
                case .restricted:
                    print("AuthorizationSatus is restricted")
                case .authorized:
                    print("AuthorizationSatus is authorized")
                @unknown default:
                    fatalError("Invalid authorization status")
                }
            }
        }
    }
}
