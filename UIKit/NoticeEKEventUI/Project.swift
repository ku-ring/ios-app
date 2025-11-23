import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.ui(
    name: "NoticeEKEventUI",
    bundleId: bundleId_release,
    dependencies: [
        .project(target: "Caches", path: "../../Caches"),
    ]
)
