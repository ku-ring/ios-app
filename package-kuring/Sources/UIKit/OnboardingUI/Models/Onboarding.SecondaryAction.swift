//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI

extension Onboarding {
    public struct SecondaryAction {
        public let title: String
        public let foregroundColor: Color
        public let hapticFeedback: Onboarding.HapticFeedback?
        public var onDismiss: (() -> Void)?
        
        /// 기본 값은 배경색이 `accentColor` , 글자색은 흰색
        public init(
            title: String = "다음",
            foregroundColor: Color = .accentColor,
            hapticFeedback: Onboarding.HapticFeedback? = .notification(.success),
            onDismiss: (() -> Void)? = nil
        ) {
            self.title = title
            self.foregroundColor = foregroundColor
            self.hapticFeedback = hapticFeedback
            self.onDismiss = onDismiss
        }
    }
}
