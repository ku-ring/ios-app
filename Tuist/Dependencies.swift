import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            requirement : .exact("1.0.0")
        ),
        .remote(
            url: "https://github.com/ku-ring/the-satellite",
            requirement : .branch("main")
        )
    ],
    platforms: [.iOS]
)
