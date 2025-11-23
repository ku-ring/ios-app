import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.ui(
    name: "LoginUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "Lottie"),
        .external(name: "ComposableArchitecture"),
        .project(target: "ColorSet", path: "../ColorSet"),
        .project(target: "LoginFeatures", path: "../../Features/LoginFeatures"),
        .project(target: "SettingsFeatures", path: "../../Features/SettingsFeatures")
    ]
)
