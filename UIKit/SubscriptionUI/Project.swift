import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.ui(
    name: "SubscriptionUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "Models", path: "../../Models"),
        .project(target: "ColorSet", path: "../ColorSet"),
        .project(target: "DepartmentUI", path: "../DepartmentUI"),
        .project(target: "DepartmentFeatures", path: "../../Features/DepartmentFeatures"),
        .project(target: "SubscriptionFeatures", path: "../../Features/SubscriptionFeatures")
    ]
)
