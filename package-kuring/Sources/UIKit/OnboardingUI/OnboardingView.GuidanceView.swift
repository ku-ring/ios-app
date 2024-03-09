//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI

extension OnboardingView {
    struct GuidanceView: View {
        let guidance: Guidance
        
        var body: some View {
            VStack(spacing: 0) {
                Image(
                    guidance.imageName,
                    bundle: Bundle.onboarding
                )
                
                Text(guidance.message)
                    .font(.system(size: 18, weight: .semibold))
            }
        }
    }
}

#Preview {
    OnboardingView.GuidanceView(guidance: .noticeList)
}
