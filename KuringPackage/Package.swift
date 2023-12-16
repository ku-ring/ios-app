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
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "observation-beta"),
        .package(url: "https://github.com/ku-ring/the-satellite", branch: "main")
    ],
    targets: [
        // MARK: App Library Dependencies
        .target(
            name: "NoticeUI",
            dependencies: [
                "NoticeFeatures", "SearchFeatures", "SubscriptionUI", "DepartmentUI", "SearchUI",
                "ColorSet",
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
        
        // MARK: Features
        .target(
            name: "NoticeFeatures",
            dependencies: [
                "Models",
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
        
        // MARK: - Shared
        
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
    ]
)
