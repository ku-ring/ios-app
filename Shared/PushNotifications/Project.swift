import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    for: .core,
    name: "PushNotifications",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "Models", path: "../Models"),
        .project(target: "Networks", path: "../Networks"),
    ]
)
