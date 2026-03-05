import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    for: .feature,
    name: "ClubsFeatures",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .project(target: "Caches", path: "../../Shared/Caches"),
        .project(target: "Models", path: "../../Shared/Models"),
        .project(target: "Networks", path: "../../Shared/Networks"),
        .project(target: "LoginFeatures", path: "../LoginFeatures")
    ]
)
