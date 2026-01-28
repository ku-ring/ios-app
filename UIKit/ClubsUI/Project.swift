import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    for: .ui,
    name: "ClubsUI",
    bundleId: bundleId_release,
    dependencies: [
        .project(target: "ColorSet", path: "../ColorSet"),
        .project(target: "CommonUI", path: "../CommonUI"),
        .project(target: "Models", path: "../../Shared/Models"),
        .project(target: "Caches", path: "../../Shared/Caches"),
    ],
    needsExample: true
)
