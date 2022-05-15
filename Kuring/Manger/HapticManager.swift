//
//  HapticEngineManager.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/03/21.
//

import UIKit
import KuringCommons

/// - NOTE: [human interface guideline](https://developer.apple.com/design/human-interface-guidelines/ios/user-interaction/haptics/)
class HapticManager {
    static let shared = HapticManager()
    
    private var impactFeedback: UIImpactFeedbackGenerator?
    private var notificationFeedback: UINotificationFeedbackGenerator?
    
    func setupGenerator() {
        impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback?.prepare()
        notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback?.prepare()
    }
    
    func createImpact() {
        impactFeedback?.impactOccurred()
        #if targetEnvironment(simulator)
        Logger.debug("👉🏼 임팩트 피드백: 덕(중)!")
        #endif
    }
    
    func createNotification(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        notificationFeedback?.notificationOccurred(notificationType)
        #if targetEnvironment(simulator)
        switch notificationType {
        case .error:
            Logger.debug("👉🏼 임팩트 피드백: 중중강약!")
        case .success:
            Logger.debug("👉🏼 임팩트 피드백: 약강!")
        case .warning:
            Logger.debug("👉🏼 임팩트 피드백: 강약!")
        default:
            Logger.debug("👉🏼 임팩트 피드백: ?!")
        }
        #endif
    }
    
    func release() {
        impactFeedback = nil
        notificationFeedback = nil
    }
}
