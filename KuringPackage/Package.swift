// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "KuringPackage",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "App",
            targets: [
                /// ```swift
                /// import NoticeUI
                /// ```
                "NoticeUI",
                "SubscriptionUI",
                "DepartmentUI",
                "SearchUI",
                "SettingsUI",
            ]
        ),
        .library(
            name: "Labs",
            targets: ["Labs"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "observation-beta"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.1.5"),
        .package(url: "https://github.com/ku-ring/the-satellite", branch: "main")
    ],
    targets: [
        // MARK: App Library Dependencies
        .target(
            name: "NoticeUI",
            dependencies: [
                "NoticeFeatures", "SearchFeatures", "SubscriptionUI", "DepartmentUI", "SearchUI",
                "ColorSet", "Caches",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
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
            name: "SearchUI",
            dependencies: [
                "SearchFeatures", "NoticeFeatures",
                "ColorSet",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/UIKit/SearchUI"
        ),
        .target(
            name: "SettingsUI",
            dependencies: [
                "SettingsFeatures", "SubscriptionFeatures", "SubscriptionUI",
                "Caches",
                "Labs",
                "ColorSet",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/UIKit/SettingsUI",
            resources: [.process("Resources")]
        ),
        
        // MARK: Features
        .target(
            name: "NoticeFeatures",
            dependencies: [
                "Models",
                "Caches",
                "DepartmentFeatures",
                "SearchFeatures",
                "SubscriptionFeatures",
                "KuringLink",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/Features/NoticeFeatures"
        ),
        .target(
            name: "SubscriptionFeatures",
            dependencies: [
                "Models",
                "DepartmentFeatures",
                "KuringLink",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/Features/SubscriptionFeatures"
        ),
        .target(
            name: "DepartmentFeatures",
            dependencies: [
                "Models",
                "KuringLink",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/Features/DepartmentFeatures"
        ),
        .target(
            name: "SearchFeatures",
            dependencies: [
                "Models",
                "KuringLink",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/Features/SearchFeatures"
        ),
        .target(
            name: "BookmarkFeatures",
            dependencies: [
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
                "Labs",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/Features/SettingsFeatures"
        ),
        
        // MARK: - Labs
        .target(
            name: "Labs",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
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
            name: "KuringLink",
            dependencies: [
                "Models",
                .product(name: "Satellite", package: "the-satellite"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "Sources/Networks",
            resources: [.process("Resources/KuringLink-Info.plist")]
        ),
        
        // MARK: Models
        .target(
            name: "Models"
        ),
        
        // MARK: - Tests
        .testTarget(
            name: "NoticeFeaturesTests",
            dependencies: [
                "NoticeFeatures", "SearchFeatures", "Models", "Caches",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
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
                "BookmarkFeatures", "Caches", "Models",
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
