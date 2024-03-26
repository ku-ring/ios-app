//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Lottie
import SwiftUI
import ColorSet

struct CompletionView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 12) {
                Text(StringSet.title_complete.rawValue)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.Kuring.primary)
                
                Text(StringSet.description_complete.rawValue)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.Kuring.caption1)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                LottieView(animation: .named("success.json", bundle: Bundle.onboarding))
                    .playing()
                    .looping()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .clipped()
                
                Spacer()
            }
            Spacer()
        }
        .padding(.top, 124)
        .background(Color.Kuring.bg)
    }
}

#Preview {
    CompletionView()
}
