//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Lottie
import SwiftUI
import ColorSet

struct CompletionView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text(StringSet.title_complete.rawValue)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.primary)
            
            Text(StringSet.description_complete.rawValue)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.caption1.opacity(0.6))
                .multilineTextAlignment(.center)
            
            Spacer()
            
            LottieView(animation: .named("success.json", bundle: Bundle.onboarding))
                .playing()
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .clipped()
            
            Spacer()
        }
        .padding(.top, 124)
    }
}

#Preview {
    CompletionView()
}
