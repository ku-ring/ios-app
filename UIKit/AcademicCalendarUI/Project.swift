import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    for: .ui,
    name: "AcademicCalendarUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "ColorSet", path: "../ColorSet"),
        .project(target: "CommonUI", path: "../CommonUI"),
        .project(target: "Models", path: "../../Shared/Models"),
        .project(target: "Caches", path: "../../Shared/Caches"),
        .project(target: "AcademicCalendarFeatures", path: "../../Features/AcademicCalendarFeatures")
    ]
)
