import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    for: .feature,
    name: "SubscriptionFeatures",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "Models", path: "../../Shared/Models"),
        .project(target: "Networks", path: "../../Shared/Networks"),
        .project(target: "DepartmentFeatures", path: "../DepartmentFeatures")
    ]
)
