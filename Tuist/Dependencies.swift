import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            requirement : .exact("1.0.0")
        ),
        .remote(
            url: "https://github.com/ku-ring/the-satellite.git",
            requirement : .branch("main")
        ),
        .remote(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            requirement : .upToNextMajor(from: "10.4.0")
        )
    ],
    platforms: [.iOS]
)

