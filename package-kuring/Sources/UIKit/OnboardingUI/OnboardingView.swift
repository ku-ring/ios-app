//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI

public struct OnboardingView: View {
    let onboarding: Onboarding
    
    public var body: some View {
        VStack(spacing: 70) {
            HStack {
                VStack(alignment: .leading) {
                    Text(onboarding.title)
                        .font(.system(size: 36, weight: .bold))
                }
                
                Spacer()
            }
            
            TabView {
                ForEach(onboarding.features) { feature in
                    FeatureView(feature: feature)
                }
            }
            .tabViewStyle(.page)
            
            Button {
                onboarding.primaryAction.onDismiss?()
            } label: {
                NextButton(
                    onboarding.primaryAction.title,
                    fontColor: onboarding.primaryAction.foregroundColor,
                    backgroundColor: onboarding.primaryAction.backgroundColor
                )
            }
            
            if let secondaryAction = onboarding.secondaryAction {
                Button(secondaryAction.title) {
                    secondaryAction.onDismiss?()
                }
                .font(.caption)
            }
            
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func NextButton(_ title: String, fontColor: Color, backgroundColor: Color) -> some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()

            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(fontColor)

            Spacer()
        }
        .padding(.horizontal, 50)
        .padding(.vertical, 16)
        .frame(height: 50, alignment: .center)
        .background(backgroundColor)
        .cornerRadius(100)
    }
}

#Preview {
    OnboardingView(
        onboarding: Onboarding(
            version: "2.0.0",
            title: "건국대 공지\n쿠링이 알려줄게!",
            features: [
                Onboarding.Feature(
                    image: Image(systemName: "star"),
                    title: "빠른 공지 확인",
                    subtitle: "학교 홈페이지에 들어갈 필요없이 메인페이지에서 공지사항을 바로 확인해 보세요."
                ),
                Onboarding.Feature(
                    image: Image(systemName: "star"),
                    title: "꼼꼼한 공지 확인",
                    subtitle: "중요한 알림을 놓치지 말고, 푸시 알림으로 꼼꼼하게 받아보세요."
                ),
                Onboarding.Feature(
                    image: Image(systemName: "star"),
                    title: "공지/교수 검색",
                    subtitle: "공지사항과 교직원 정보를 빠르게 검색해 볼 수 있어요."
                ),
            ],
            primaryAction: .init(
                title: "공지 알림 설정하러 가기",
                hapticFeedback: .notification(.success),
                onDismiss: { }
            ),
            secondaryAction: nil
//                .init(
//                title: "설명 괜찮아요. 바로 시작할게요!",
//                foregroundColor: <#T##Color#>,
//                hapticFeedback: .selection,
//                onDismiss: { }
//            )
        )
    )
}

/**
 ```swift
 struct ContentView: View {
    var body: some View {
        NavigationView {
            // ...
        }
        .onboadingCover()
    }
 }
 ```
 */

/**
 ```swift
 ContentView()
    .environment(
        \.onboarding,
        OnboardingValues(
            history: self.onboardingHistory
        )
 ```
 
 ```swift
 var onboardingHistory: OnboardingHistory {
    Onboarding(
        version: "2.0.0",
        // ...
    )
 
     Onboarding(
         version: "2.1.0",
         // ...
     )
     
     Onboarding(
         version: "2.2.0",
         // ...
     )
 }
 ```
 */

/**
 ```swift
 let onboarding = Onboarding(
    version: "2.0.0",
    title: "건국대 공지\n쿠링이 알려줄게!",
    features: [
        Onboarding.Feature(
            image: .init(image: ""),
            title: "빠른 공지 확인",
            subtitle: "학교 홈페이지에 들어갈 필요없이 메인페이지에서 공지사항을 바로 확인해 보세요."
        )
    ],
    primaryAction: Onboarding.PrimaryAction(
        title: "다음",
        backgroundColor: .accentColor,
        foregroundColor: .white,
        hapticFeedback: .notification(.success),
        onDismiss: { 
            // ...
        }
    ),
    secondaryAction: Onboarding.SecondaryAction(
        title: "설명 괜찮아요. 바로 시작할게요!",
        foregroundColor: .secondary,
        hapticFeedback: .selection,
        onDismiss: {
            // ...
        }
    )
 )
 ```
 */


/**
 ```swift
 struct ContentView: View {
    @State private var on onboarding: Onboarding? = Onboarding(
        title: "건국대 공지\n쿠링이 알려줄게!",
        features: [
            .init(image: ""),
            title: "빠른 공지 확인",
            subtitle: "학교 홈페이지에 들어갈 필요없이 메인페이지에서 공지사항을 바로 확인해 보세요."
        ]
    )
 
    var body: some View {
        NavigationView {
            // ...
        }
        .fullScreenCover(onboarding: $onboarding)
        // .sheet(onboarding: $onboarding)
    }
 ```
 */
