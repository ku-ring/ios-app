// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "package-kuring",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "App",
            targets: [
                /// ```swift
                /// import NoticeUI
                /// ```
                "BotUI",
                "NoticeUI",
                "SubscriptionUI",
                "DepartmentUI",
                "SearchUI",
                "BookmarkUI",
                "SettingsUI",
                "CampusUI",
                "CommonUI",
                "OnboardingUI",
                "LoginUI",
                "AcademicCalendarUI",
                "PushNotifications",
            ]
        ),
        .library(
            name: "PushNotifications",
            targets: ["PushNotifications"]
        ),
        .library(
            name: "Labs",
            targets: ["Labs"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.12.1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", exact: "1.9.3"),
        .package(url: "https://github.com/apple/swift-collections.git", exact: "1.1.0"),
        .package(url: "https://github.com/ku-ring/the-satellite", branch: "main"),
        .package(url: "https://github.com/ku-ring/ios-maps", branch: "2.2.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.50.4"),
        .package(url: "https://github.com/ku-ring/package-activityui", branch: "main"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.21.0"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.4.1"),
    ],
    targets: [
        // MARK: App Library Dependencies
        .target(
            name: "AcademicCalendarUI",
            dependencies: [
                "ColorSet",
                "Caches",
                "CommonUI",
                "AcademicCalendarFeatures",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/UIKit/AcademicCalendarUI"
        ),
        .target(
            name: "NoticeEKEventUI",
            dependencies: [
                "Caches"
            ],
            path: "Sources/UIKit/NoticeEKEventUI"
        ),
        .target(
            name: "BotUI",
            dependencies: [
                .product(name: "Lottie", package: "lottie-spm"),
                "ColorSet", "BotFeatures",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "Sources/UIKit/BotUI",
            resources: [.process("Resources")]
        ),
        .target(
            name: "NoticeUI",
            dependencies: [
                "NoticeFeatures",
                "SearchFeatures",
                "SubscriptionUI",
                "DepartmentUI",
                "SearchUI",
                "CommonUI",
                "LoginUI",
                "ColorSet",
                "Caches",
                "BotUI",
                "BotFeatures",
                "DepartmentFeatures",
                "NoticeEKEventUI",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "ActivityUI", package: "package-activityui"),
            ],
            path: "Sources/UIKit/NoticeUI",
            resources: [.process("Resources")]
        ),
        .target(
            name: "SubscriptionUI",
            dependencies: [
                "SubscriptionFeatures", "DepartmentUI", "DepartmentFeatures",
                "ColorSet",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/UIKit/SubscriptionUI",
            resources: [.process("Resources")]
        ),
        .target(
            name: "DepartmentUI",
            dependencies: [
                "DepartmentFeatures",
                "ColorSet",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/UIKit/DepartmentUI"
        ),
        .target(
            name: "LoginUI",
            dependencies: [
                "LoginFeatures",
                "SettingsFeatures",
                "ColorSet",
                .product(name: "Lottie", package: "lottie-spm"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/UIKit/LoginUI",
            resources: [.process("Resources")]
        ),
        .target(
            name: "SearchUI",
            dependencies: [
                "SearchFeatures", "NoticeFeatures",
                "ColorSet",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/UIKit/SearchUI"
        ),
        .target(
            name: "BookmarkUI",
            dependencies: [
                "BookmarkFeatures",
                "NoticeUI",
                "LoginUI",
                "NoticeFeatures",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/UIKit/BookmarkUI"
        ),
        .target(
            name: "SettingsUI",
            dependencies: [
                "SettingsFeatures",
                "SubscriptionFeatures",
                "SubscriptionUI",
                "LoginFeatures",
                "LoginUI",
                "Caches",
                "Labs",
                "ColorSet",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/UIKit/SettingsUI",
            resources: [.process("Resources")]
        ),
        .target(
            name: "CampusUI",
            dependencies: [
                "ColorSet",
                .product(name: "KuringMapsUI", package: "ios-maps")
            ],
            path: "Sources/UIKit/CampusUI",
            resources: [.process("Resources")]
        ),
        .target(
            name: "CommonUI",
            dependencies: [
                "Networks",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/UIKit/CommonUI"
        ),
        .target(
            name: "OnboardingUI",
            dependencies: [
                "DepartmentUI",
                "Networks",
                "ColorSet",
                "Caches",
                .product(name: "Lottie", package: "lottie-spm"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "Sources/UIKit/OnboardingUI",
            resources: [.process("Resources")]
        ),
        
        // MARK: Features
        .target(
            name: "AcademicCalendarFeatures",
            dependencies: [
                "Networks",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/Features/AcademicCalendarFeatures"
        ),
        .target(
            name: "BotFeatures",
            dependencies: [
                "Networks",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "Sources/Features/BotFeatures"
        ),
        .target(
            name: "NoticeFeatures",
            dependencies: [
                "Models",
                "Caches",
                "DepartmentFeatures",
                "SearchFeatures",
                "LoginFeatures",
                "SubscriptionFeatures",
                "Networks",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "ActivityUI", package: "package-activityui"),
            ],
            path: "Sources/Features/NoticeFeatures"
        ),
        .target(
            name: "SubscriptionFeatures",
            dependencies: [
                "Models",
                "DepartmentFeatures",
                "Networks",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/Features/SubscriptionFeatures"
        ),
        .target(
            name: "DepartmentFeatures",
            dependencies: [
                "Models",
                "Caches",
                "Networks",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/Features/DepartmentFeatures"
        ),
        .target(
            name: "LoginFeatures",
            dependencies: [
                "Models",
                "Caches",
                "Networks",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/Features/LoginFeatures"
        ),
        .target(
            name: "SearchFeatures",
            dependencies: [
                "Models",
                "Networks",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/Features/SearchFeatures"
        ),
        .target(
            name: "BookmarkFeatures",
            dependencies: [
                "NoticeFeatures",
                "LoginFeatures",
                "Models",
                "Caches",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/Features/BookmarkFeatures"
        ),
        .target(
            name: "SettingsFeatures",
            dependencies: [
                "Models",
                "Caches",
                "SubscriptionFeatures",
                "LoginFeatures",
                "AcademicCalendarFeatures",
                "Labs",
                "Networks",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/Features/SettingsFeatures"
        ),
        
        // MARK: - Labs
        .target(
            name: "Labs",
            dependencies: [
                "ColorSet",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        
        // MARK: - Push Notifications
        .target(
            name: "PushNotifications",
            dependencies: [
                "Models",
                "Networks",
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        
        // MARK: - Shared
        
        // MARK: Caches
        .target(
            name: "Caches",
            dependencies: [
                "Models",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            path: "Sources/Caches"
        ),
        
        // MARK: Colors
        .target(
            name: "ColorSet",
            path: "Sources/UIKit/ColorSet"
        ),
        // MARK: Networks
        .target(
            name: "Networks",
            dependencies: [
                "Models",
                .product(name: "Satellite", package: "the-satellite"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Collections", package: "swift-collections"),
            ],
            path: "Sources/Networks",
            resources: [.process("Resources/KuringLink-Info.plist")]
        ),
        
        // MARK: Models
        .target(
            name: "Models",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
            ]
        ),
        
        // MARK: - Tests
        .testTarget(
            name: "NoticeFeaturesTests",
            dependencies: [
                "NoticeFeatures",
                "SearchFeatures",
                "Models",
                "Caches",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "ActivityUI", package: "package-activityui"),
            ]
        ),
        .testTarget(
            name: "SubscriptionFeaturesTests",
            dependencies: [
                "SubscriptionFeatures", "DepartmentFeatures", "Models",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "BookmarkFeaturesTests",
            dependencies: [
                "BookmarkFeatures",
                "Caches",
                "Models",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "NetworksTests",
            dependencies: [
                "Networks",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "LabsTests",
            dependencies: [
                "Labs",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
    ]
)
