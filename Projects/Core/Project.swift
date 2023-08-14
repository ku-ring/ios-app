import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "CoreKit",
    targets: [
        .make(
            name: "CoreKit",
            product: .staticLibrary,
            bundleId: "team.kuring.corekit",
            sources: ["Sources/**"],
            dependencies: []
        ),
        .unitTests(name: "CoreKit")
    ]
)
