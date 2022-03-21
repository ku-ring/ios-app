//
//  HapticEngineManager.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/03/21.
//

// https://developer.apple.com/design/human-interface-guidelines/ios/user-interaction/haptics/
import UIKit

class HapticsManager {
    
    static private var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    
    static func impactHeavy() {
        HapticsManager.impactFeedbackGenerator = UIImpactFeedbackGenerator()
        HapticsManager.impactFeedbackGenerator?.impactOccurred()
    }
}
