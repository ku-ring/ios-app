import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.lab(
    name: "Labs",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "ColorSet", path: "../UIKit/ColorSet"),
    ]
)
