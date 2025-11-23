import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.ui(
    name: "BotUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "Lottie"),
        .external(name: "ComposableArchitecture"),
        .project(target: "Models", path: "../../Models"),
        .project(target: "ColorSet", path: "../ColorSet"),
        .project(target: "BotFeatures", path: "../../Features/BotFeatures")
    ]
)
