import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "App",
    packages: [
        .remote(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            requirement : .upToNextMajor(from: "10.4.0")
        )
    ],
    targets: [
        .make(
            name: "Kuring",
            product: .app,
            bundleId: "com.kuring.service",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "KuringLink", path: .relativeToRoot("Projects/KuringLink")),
                .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
                .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
                .external(name: "ComposableArchitecture"),
                .package(product: "FirebaseMessaging")
            ]
        ),
        .make(
            name: "Kuring-Dev",
            product: .app,
            bundleId: "com.kuring.service-dev",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "KuringLink", path: .relativeToRoot("Projects/KuringLink")),
                .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
                .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
                .external(name: "ComposableArchitecture"),
                .package(product: "FirebaseMessaging")
            ]
        )
    ]
)

