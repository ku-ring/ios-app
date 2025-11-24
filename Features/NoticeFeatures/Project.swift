import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    for: .feature,
    name: "NoticeFeatures",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ActivityUI"),
        .external(name: "ComposableArchitecture"),
        .project(target: "Models", path: "../../Shared/Models"),
        .project(target: "Caches", path: "../../Shared/Caches"),
        .project(target: "Networks", path: "../../Shared/Networks"),
        .project(target: "LoginFeatures", path: "../LoginFeatures"),
        .project(target: "SearchFeatures", path: "../SearchFeatures"),
        .project(target: "DepartmentFeatures", path: "../DepartmentFeatures"),
        .project(target: "SubscriptionFeatures", path: "../SubscriptionFeatures"),
        .project(target: "AcademicCalendarFeatures", path: "../AcademicCalendarFeatures")
    ]
)
