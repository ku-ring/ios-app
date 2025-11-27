import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    for: .ui,
    name: "BotUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "Lottie"),
        .external(name: "ComposableArchitecture"),
        .project(target: "ColorSet", path: "../ColorSet"),
        .project(target: "Models", path: "../../Shared/Models"),
        .project(target: "BotFeatures", path: "../../Features/BotFeatures")
    ]
)
