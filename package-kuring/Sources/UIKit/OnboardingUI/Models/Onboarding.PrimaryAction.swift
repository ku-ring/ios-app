//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI

extension Onboarding {
    public struct PrimaryAction {
        public let title: String
        public let backgroundColor: Color
        public let foregroundColor: Color
        public let hapticFeedback: Onboarding.HapticFeedback?
        public var onDismiss: (() -> Void)?
        
        /// 기본 값은 배경색이 `accentColor` , 글자색은 흰색
        public init(
            title: String = "다음",
            backgroundColor: Color = .accentColor,
            foregroundColor: Color = .white,
            hapticFeedback: Onboarding.HapticFeedback? = .notification(.success),
            onDismiss: (() -> Void)? = nil
        ) {
            self.title = title
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
            self.hapticFeedback = hapticFeedback
            self.onDismiss = onDismiss
        }
    }
}
