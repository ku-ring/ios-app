//
//  InAppReview.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/03/04.
//

import UIKit
import StoreKit

class AppStoreReviewManager {
    /// action count 값이 3일 때 `true` 입니다.
    static var isReviewable: Bool { UserDefaultManager.inAppReviewCount == 3 }
    
    static func requestReviewIfAppropriate() {
        guard UserDefaultManager.inAppReviewCount <= 3 else { return }
        UserDefaultManager.inAppReviewCount += 1

        guard isReviewable else { return }
        let scene = UIApplication.shared.connectedScenes.first { $0.activationState == .foregroundActive }
        if let scene = scene as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
