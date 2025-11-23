import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.ui(
    name: "SettingsUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "ColorSet", path: "../ColorSet"),
        .project(target: "Caches", path: "../../Caches"),
        .project(target: "Labs", path: "../../Labs"),
        .project(target: "SettingsFeatures", path: "../../Features/SettingsFeatures"),
        .project(target: "SubscriptionFeatures", path: "../../Features/SubscriptionFeatures"),
        .project(target: "LoginFeatures", path: "../../Features/LoginFeatures"),
        .project(target: "SubscriptionUI", path: "../../UIKit/SubscriptionUI"),
        .project(target: "LoginUI", path: "../../UIKit/LoginUI"),
    ]
)
