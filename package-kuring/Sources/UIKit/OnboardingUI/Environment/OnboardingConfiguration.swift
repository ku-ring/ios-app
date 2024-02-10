//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

public class OnboardingConfiguration {
    public let currentVersion: Onboarding.Version
    public let versionStorage: String
    public let onboardingCollection: [String]
    
    public init(
        currentVersion: Onboarding.Version = .current(),
        versionStorage: String,
        onboardingCollection: [String]
    ) {
        self.currentVersion = currentVersion
        self.versionStorage = versionStorage
        self.onboardingCollection = onboardingCollection
    }
}
