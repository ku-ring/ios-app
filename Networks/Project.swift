import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.network(
    name: "Networks",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "Satellite"),
        .external(name: "Collections"),
        .external(name: "Dependencies"),
        .project(target: "Models", path: "../Models"),
    ]
)
