import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    for: .ui,
    name: "SettingsUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "Labs", path: "../../Labs"),
        .project(target: "ColorSet", path: "../ColorSet"),
        .project(target: "Caches", path: "../../Shared/Caches"),
        .project(target: "LoginUI", path: "../../UIKit/LoginUI"),
        .project(target: "SubscriptionUI", path: "../../UIKit/SubscriptionUI"),
        .project(target: "LoginFeatures", path: "../../Features/LoginFeatures"),
        .project(target: "SettingsFeatures", path: "../../Features/SettingsFeatures"),
        .project(target: "SubscriptionFeatures", path: "../../Features/SubscriptionFeatures")
    ]
)
