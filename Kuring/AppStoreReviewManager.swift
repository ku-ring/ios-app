//
//  InAppReview.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/03/04.
//

import UIKit
import StoreKit

class AppStoreReviewManager {
    
    static var isReviewable: Bool {
        UserDefaultManager.inAppReviewCount >= 3 // minimum reviewable action count
    }
    
    static func requestReviewIfAppropriate() {
        
        UserDefaultManager.inAppReviewCount += 1
        guard isReviewable else { return }
        
        let lastVersion = UserDefaultManager.appVersion
        
        if lastVersion != Bundle.appVersion {
            SKStoreReviewController.requestReview()
            UserDefaultManager.appVersion = Bundle.appVersion
        }
        
    }
}
