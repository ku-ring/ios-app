import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.ui(
    name: "SearchUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "Models", path: "../../Models"),
        .project(target: "ColorSet", path: "../ColorSet"),
        .project(target: "SearchFeatures", path: "../../Features/SearchFeatures"),
        .project(target: "NoticeFeatures", path: "../../Features/NoticeFeatures"),
    ]
)
