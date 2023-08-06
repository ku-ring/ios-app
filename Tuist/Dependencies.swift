import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            requirement : .exact("1.0.0")
        ),
        .remote(
            url: "https://github.com/johnpatrickmorgan/TCACoordinators.git",
            requirement : .exact("0.6.0")
        ),
        .remote(
            url: "https://github.com/ku-ring/the-satellite.git",
            requirement : .branch("main")
        ),
        
    ],
    platforms: [.iOS]
)

