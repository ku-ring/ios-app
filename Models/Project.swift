import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.model(
    name: "Models",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "Collections"),
        .project(target: "ColorSet", path: "../UIKit/ColorSet"),
    ]
)
