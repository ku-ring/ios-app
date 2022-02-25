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
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) { }
    
    func onConversionDataFail(_ error: Error) { }
}
