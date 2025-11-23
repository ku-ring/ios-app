import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.pushNotifications(
    name: "PushNotifications",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "Models", path: "../Models"),
        .project(target: "Networks", path: "../Networks"),
    ]
)
