import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.ui(
    name: "CampusUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "KuringMapsUI"),
        .project(target: "ColorSet", path: "../ColorSet"),
    ]
)
