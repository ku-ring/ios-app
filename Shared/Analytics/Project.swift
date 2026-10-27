import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    for: .core,
    name: "Analytics",
    bundleId: bundleId_release,
    dependencies: [
        .external(name: "ComposableArchitecture"),
        .external(name: "AmplitudeSwift")
    ]
)
