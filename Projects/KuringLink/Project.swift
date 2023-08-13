import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "KuringLink",
    targets: [
        .make(
            name: "KuringLink",
            product: .framework,
            bundleId: "com.kuring.kuringlink",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "Satellite"),
                .external(name: "Cache")
            ]
        ),
        .unitTests(name: "KuringLink")
    ]
)
