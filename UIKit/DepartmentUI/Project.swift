import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.ui(
    name: "DepartmentUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "Models", path: "../../Models"),
        .project(target: "ColorSet", path: "../ColorSet"),
        .project(target: "DepartmentFeatures", path: "../../Features/DepartmentFeatures")
    ]
)
