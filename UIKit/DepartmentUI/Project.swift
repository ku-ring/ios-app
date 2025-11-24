import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    for: .ui,
    name: "DepartmentUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "ColorSet", path: "../ColorSet"),
        .project(target: "Models", path: "../../Shared/Models"),
        .project(target: "DepartmentFeatures", path: "../../Features/DepartmentFeatures")
    ]
)
