//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import ColorSet
import Dependencies

public struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentGuidance: Guidance.ID = .subscription
    @State private var showsDepartmentSelector: Bool = false
    
    @Dependency(\.commons) var commons
    
    public var body: some View {
        if showsDepartmentSelector {
            MyDepartmentSelector()
                .background(Color.Kuring.bg)
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
                                ? Color.Kuring.primary
                                : Color(.systemGroupedBackground)
                            )
                    }
                }
                .padding(8)
                .padding(.vertical, 60)
                
                Button {
                    commons.changeOnboarding(true)
                    showsDepartmentSelector = true
                } label: {
                    Text(StringSet.button_goSubscrbing.rawValue)
                }
                .buttonStyle(.kuringStyle(enabled: currentGuidance == .search))
                
                Button(StringSet.button_skip.rawValue) {
                    commons.changeOnboarding(true)
                    dismiss()
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
                .padding(.vertical, 20)
            }
            .padding(.horizontal, 20)
            .background(Color.Kuring.bg)
        }
    }
    
    public init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.Kuring.primary)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.Kuring.gray200)
    }
}

#Preview {
    OnboardingView()
}

