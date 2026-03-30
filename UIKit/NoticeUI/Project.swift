import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    for: .ui,
    name: "NoticeUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ActivityUI"),
        .external(name: "ComposableArchitecture"),
        .project(target: "BotUI", path: "../BotUI"),
        .project(target: "ClubsUI", path: "../ClubsUI"),
        .project(target: "LoginUI", path: "../LoginUI"),
        .project(target: "SearchUI", path: "../SearchUI"),
        .project(target: "CommonUI", path: "../CommonUI"),
        .project(target: "ColorSet", path: "../ColorSet"),
        .project(target: "Models", path: "../../Shared/Models"),
        .project(target: "Caches", path: "../../Shared/Caches"),
        .project(target: "DepartmentUI", path: "../DepartmentUI"),
        .project(target: "NoticeEKEventUI", path: "../NoticeEKEventUI"),
        .project(target: "BotFeatures", path: "../../Features/BotFeatures"),
        .project(target: "AcademicCalendarUI", path: "../AcademicCalendarUI"),
        .project(target: "NoticeFeatures", path: "../../Features/NoticeFeatures"),
        .project(target: "SearchFeatures", path: "../../Features/SearchFeatures"),
        .project(target: "DepartmentFeatures", path: "../../Features/DepartmentFeatures")
    ],
    needsExample: true
)
