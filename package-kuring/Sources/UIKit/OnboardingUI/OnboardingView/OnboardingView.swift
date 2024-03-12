//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI

public struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentGuidance: Guidance.ID = .subscription
    @State private var showsDepartmentSelector: Bool = false
    
    public var body: some View {
        if showsDepartmentSelector {
            MyDepartmentSelector()
        } else {
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
                .tabViewStyle(.page(indexDisplayMode: .never))
                
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
                    showsDepartmentSelector = true
                } label: {
                    Text(StringSet.button_goSubscrbing.rawValue)
                }
                .buttonStyle(.kuringStyle(enabled: currentGuidance == .search))
                
                Button(StringSet.button_skip.rawValue) {
                    dismiss()
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.caption1.opacity(0.6))
                .padding(.vertical, 20)
            }
            .padding(.horizontal, 20)
        }
    }
    
    public init() { }
}

#Preview {
    OnboardingView()
}

