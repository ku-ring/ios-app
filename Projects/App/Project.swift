import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "App",
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
                .externalsrt("TCA")
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
                .externalsrt("TCA")
            ]
        )
    ]
)

