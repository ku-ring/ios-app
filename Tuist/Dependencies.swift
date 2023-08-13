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
            url: "https://github.com/cozzin/Cache",
            requirement: .upToNextMajor(from: "1.0.0")
        )
        
    ],
    platforms: [.iOS]
)

