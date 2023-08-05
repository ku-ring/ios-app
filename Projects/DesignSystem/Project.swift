import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "DesignSystem",
    targets: [
        .make(
            name: "DesignSystem",
            product: .framework,
            bundleId: "com.kuring.designsystem",
            sources: ["Sources/**"],
            resources: ["Resources/**"]
        )
    ]
)
