//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI

extension OnboardingView {
    public struct FeatureView { 
        let feature: Onboarding.Feature
    }
}

extension OnboardingView.FeatureView: View {
    public var body: some View {
        VStack(spacing: 8) {
            Rectangle() // feature.image
                .frame(width: 200, height: 200)
                .padding(.bottom, 44)

            Text(feature.title)
                .font(.system(size: 18, weight: .bold))
            
            Text(feature.subtitle)
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 50)
    }
}
