import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.feature(
    name: "NoticeFeatures",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ActivityUI"),
        .external(name: "ComposableArchitecture"),
        .project(target: "Models", path: "../../Models"),
        .project(target: "Caches", path: "../../Caches"),
        .project(target: "Networks", path: "../../Networks"),
        .project(target: "DepartmentFeatures", path: "../DepartmentFeatures"),
        .project(target: "SearchFeatures", path: "../SearchFeatures"),
        .project(target: "LoginFeatures", path: "../LoginFeatures"),
        .project(target: "SubscriptionFeatures", path: "../SubscriptionFeatures"),
        .project(target: "AcademicCalendarFeatures", path: "../AcademicCalendarFeatures"),
    ]
)
