import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.feature(
    name: "AcademicCalendarFeatures",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "Caches", path: "../../Caches"),
        .project(target: "Networks", path: "../../Networks")
    ]
)
