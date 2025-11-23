import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.feature(
    name: "SubscriptionFeatures",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "Models", path: "../../Models"),
        .project(target: "Networks", path: "../../Networks"),
        .project(target: "DepartmentFeatures", path: "../DepartmentFeatures")
    ]
)
