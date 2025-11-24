import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    for: .ui,
    name: "NoticeEKEventUI",
    bundleId: bundleId_release,
    dependencies: [
        .project(target: "Caches", path: "../../Shared/Caches"),
    ]
)
