//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI

public struct OnboardingView: View {
    @State private var currentGuidance: Guidance.ID = .subscription
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(StringSet.title.rawValue)
                    .font(.system(size: 24, weight: .bold))
                
                Spacer()
            }
            .padding(.top, 56)
            
            TabView(selection: $currentGuidance) {
                ForEach(Guidance.allCases) { guidance in
                    GuidanceView(guidance: guidance)
                        .tag(guidance.id)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            
            HStack(spacing: 8) {
                ForEach(Guidance.allCases) { guidance in
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundStyle(
                            currentGuidance == guidance
                            ? Color.accentColor
                            : Color(.systemGroupedBackground)
                        )
                }
            }
            .padding(8)
            .padding(.vertical, 60)
            
            Button {
                
            } label: {
                Text(StringSet.button_goSubscrbing.rawValue)
            }
            .buttonStyle(.kuringStyle(enabled: currentGuidance == .search))
        }
        .padding(.horizontal, 20)
    }
    
    public init() { }
}

#Preview {
    OnboardingView()
}

