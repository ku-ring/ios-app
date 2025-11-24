import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    for: .ui,
    name: "SearchUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "ColorSet", path: "../ColorSet"),
        .project(target: "Models", path: "../../Shared/Models"),
        .project(target: "SearchFeatures", path: "../../Features/SearchFeatures"),
        .project(target: "NoticeFeatures", path: "../../Features/NoticeFeatures"),
    ]
)
