//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI

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

public struct Onboarding {
    public let version: Self.Version
    public let title: String
    public let features: [Self.Feature]
    public let primaryAction: Self.PrimaryAction
    public let secondaryAction: Self.SecondaryAction?
    
    init(
        version: Self.Version,
        title: String,
        features: [Self.Feature],
        primaryAction: Self.PrimaryAction = .init(),
        secondaryAction: Self.SecondaryAction? = nil
    ) {
        self.version = version
        self.title = title
        self.features = features
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
}

extension Onboarding: Identifiable {
    public var id: Self.Version {
        self.version
    }
}
