import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    for: .core,
    name: "Caches",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "Models", path: "../Models")
    ]
)
