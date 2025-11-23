import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.cache(
    name: "Caches",
    bundleId: bundleId_release,
    dependencies: [
        .project(target: "Models", path: "../Models"),
        .external(name: "ComposableArchitecture")
    ]
)
