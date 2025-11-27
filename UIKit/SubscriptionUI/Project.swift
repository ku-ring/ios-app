import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    for: .ui,
    name: "SubscriptionUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "ColorSet", path: "../ColorSet"),
        .project(target: "Models", path: "../../Shared/Models"),
        .project(target: "DepartmentUI", path: "../DepartmentUI"),
        .project(target: "DepartmentFeatures", path: "../../Features/DepartmentFeatures"),
        .project(target: "SubscriptionFeatures", path: "../../Features/SubscriptionFeatures")
    ]
)
