// swift-tools-version: 6.0
@preconcurrency import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

let packageSettings = PackageSettings(
    productTypes: [
        "ComposableArchitecture": .staticFramework,
        "Dependencies": .staticFramework,
        "Collections": .staticFramework,
        "KuringMapsUI": .staticFramework,
        "Satellite": .framework,
        "ActivityUI": .framework,
        "FirebaseMessaging": .staticFramework,
        "Lottie": .framework
    ]
)
#endif

let package = Package(
    name: "KuringApp",
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.12.1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", exact: "1.9.3"),
        .package(url: "https://github.com/pointfreeco/swift-concurrency-extras", exact: "1.3.2"),
        .package(url: "https://github.com/apple/swift-collections.git", exact: "1.1.0"),
        .package(url: "https://github.com/ku-ring/ios-maps", branch: "version/2.4.0"),
        .package(url: "https://github.com/ku-ring/package-activityui", branch: "main"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.24.0"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.4.1"),
        .package(url: "https://github.com/ku-ring/the-satellite-extended", branch: "main")
    ]
)
