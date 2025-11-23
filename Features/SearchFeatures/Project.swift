import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.feature(
    name: "SearchFeatures",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "Models", path: "../../Models"),
        .project(target: "Caches", path: "../../Caches"),
        .project(target: "Networks", path: "../../Networks")
    ]
)
