import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.ui(
    name: "CommonUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "Networks", path: "../../Networks"),
    ]
)
