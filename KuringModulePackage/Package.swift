// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KuringModulePackage",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Notices",
            targets: ["NoticeListFeature" ,"Model"]
        ),
        .library(
            name: "Feedbacks",
            targets: ["FeedbackFeature"]
        ),
        .library(
            name: "Subscriptions",
            targets: ["SubscriptionFeature"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "main"),
        .package(url: "https://github.com/ku-ring/the-satellite", branch: "main")
    ],
    targets: [
        // MARK: Network
        .target(
            name: "KuringLink",
            dependencies: [
                .product(name: "Satellite", package: "the-satellite"),
                "Model"
            ],
            path: "Sources/Network/KuringLink",
            resources: [.process("Resources/KuringLink-Info.plist")]
        ),
        .testTarget(
            name: "KuringLinkTests",
            dependencies: [
                .product(name: "Satellite", package: "the-satellite"),
                "KuringLink",
                "Model"
            ],
            path: "Tests/Network/KuringLinkTests"
        ),
        
        // MARK: Dependencies
        .target(
            name: "KuringDependencies",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "KuringLink",
                "Model"
            ],
            path: "Sources/Dependency"
        ),
        
        // MARK: Features
        .target(
            name: "NoticeListFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "Model",
                "KuringDependencies"
            ],
            path: "Sources/Feature/NoticeList"
        ),
        .testTarget(
            name: "NoticeListFeatureTests",
            dependencies: ["NoticeListFeature", "Model"],
            path: "Tests/Feature/NoticeListFeatureTests"
        ),
        
        .target(
            name: "FeedbackFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "Model"
            ],
            path: "Sources/Feature/Feedback"
        ),
        .testTarget(
            name: "FeedbackFeatureTests",
            dependencies: ["FeedbackFeature", "Model"],
            path: "Tests/Feature/FeedbackFeatureTests"
        ),
        
        .target(
            name: "SubscriptionFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "Model"
            ],
            path: "Sources/Feature/Subscriptions",
            resources: [.process("Resources")]
        ),
        
        // MARK: Shared
        .target(
            name: "Model",
            path: "Sources/Shared/Model"
        ),
    ]
)
