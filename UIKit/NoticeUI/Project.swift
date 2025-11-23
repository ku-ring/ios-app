import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.ui(
    name: "NoticeUI",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ActivityUI"),
        .external(name: "ComposableArchitecture"),
        .project(target: "Models", path: "../../Models"),
        .project(target: "Caches", path: "../../Caches"),
        .project(target: "NoticeFeatures", path: "../../Features/NoticeFeatures"),
        .project(target: "SearchFeatures", path: "../../Features/SearchFeatures"),
        .project(target: "BotFeatures", path: "../../Features/BotFeatures"),
        .project(target: "DepartmentFeatures", path: "../../Features/DepartmentFeatures"),
        .project(target: "SubscriptionUI", path: "../SubscriptionUI"),
        .project(target: "NoticeEKEventUI", path: "../NoticeEKEventUI"),
        .project(target: "DepartmentUI", path: "../DepartmentUI"),
        .project(target: "BotUI", path: "../BotUI"),
        .project(target: "SearchUI", path: "../SearchUI"),
        .project(target: "CommonUI", path: "../CommonUI"),
        .project(target: "LoginUI", path: "../LoginUI"),
        .project(target: "ColorSet", path: "../ColorSet"),
    ]
)
