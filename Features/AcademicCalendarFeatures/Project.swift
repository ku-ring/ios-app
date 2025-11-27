import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    for: .feature,
    name: "AcademicCalendarFeatures",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "Caches", path: "../../Shared/Caches"),
        .project(target: "Networks", path: "../../Shared/Networks")
    ]
)
