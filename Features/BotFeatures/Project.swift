import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.feature(
    name: "BotFeatures",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "Networks", path: "../../Networks"),
        .project(target: "Caches", path: "../../Caches"),
        .project(target: "Models", path: "../../Models")
    ]
)
