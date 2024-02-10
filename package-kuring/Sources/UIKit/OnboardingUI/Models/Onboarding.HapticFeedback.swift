//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation
#if os(iOS)
import UIKit
#endif

extension Onboarding {
    public enum HapticFeedback: Hashable {
        #if os(iOS) // TODO: visionOS 처리도 필요?
        /// 임팩트 피드백
        case impact(
            style: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
            intensity: CGFloat? = nil
        )
        /// 선택에 대한 피드백
        case selection
        /// 알림에 대한 피드백
        case notification(
            UINotificationFeedbackGenerator.FeedbackType = .success
        )
        #endif
    }
}

extension Onboarding.HapticFeedback {
    public func callAsFunction() {
        #if os(iOS)
        switch self {
        case let .impact(style, intensity):
            let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
            if let intensity {
                feedbackGenerator.impactOccurred(intensity: intensity)
            } else {
                feedbackGenerator.impactOccurred()
            }
        
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
            
        case let .notification(type):
            UINotificationFeedbackGenerator().notificationOccurred(type)
        }
        #endif
    }
}
