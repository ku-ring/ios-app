import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.ui(
    name: "AcademicCalendarUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "Models", path: "../../Models"),
        .project(target: "Caches", path: "../../Caches"),
        .project(target: "CommonUI", path: "../CommonUI"),
        .project(target: "ColorSet", path: "../ColorSet"),
        .project(target: "AcademicCalendarFeatures", path: "../../Features/AcademicCalendarFeatures")
    ]
)
