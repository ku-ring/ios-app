//
//  InAppReview.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/03/04.
//

import Foundation
import UIKit

import StoreKit

class AppStroeReviewManager {
    
    static let minimumReviewWorthyActionCount = 36
    
    static func requestReviewIfAppropriate() {
        
        var actionCount = Int(UserManager.inAppReviewCount ?? 0)
        actionCount += 1
        UserManager.inAppReviewCount = actionCount
        
        guard actionCount >= minimumReviewWorthyActionCount else { return }
       
        let appVersion =  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
        let lastVersion = UserManager.appVersion
        
        if lastVersion != appVersion {
            SKStoreReviewController.requestReview()
            UserManager.appVersion = appVersion
        }
        
    }
}
