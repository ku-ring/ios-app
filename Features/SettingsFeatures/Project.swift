import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.feature(
    name: "SettingsFeatures",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "Labs", path: "../../Labs"),
        .project(target: "Models", path: "../../Models"),
        .project(target: "Caches", path: "../../Caches"),
        .project(target: "Networks", path: "../../Networks"),
        .project(target: "SubscriptionFeatures", path: "../SubscriptionFeatures"),
        .project(target: "LoginFeatures", path: "../LoginFeatures"),
        .project(target: "AcademicCalendarFeatures", path: "../AcademicCalendarFeatures"),
    ]
)
