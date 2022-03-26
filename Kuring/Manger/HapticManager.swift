//
//  HapticEngineManager.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/03/21.
//

import UIKit

/// - NOTE: [human interface guideline](https://developer.apple.com/design/human-interface-guidelines/ios/user-interaction/haptics/)
class HapticManager {
    static let shared = HapticManager()
    
    private var generator: UIImpactFeedbackGenerator?
    
    func setupGenerator() {
        generator = UIImpactFeedbackGenerator()
        generator?.prepare()
    }
    
    func createImpact(style: UIImpactFeedbackGenerator.FeedbackStyle = .heavy) {
        generator?.impactOccurred()
    }
    
    func release() {
        generator = nil
    }
}
