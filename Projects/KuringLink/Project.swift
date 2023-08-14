import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "KuringLink",
    targets: [
        .make(
            name: "KuringLink",
            product: .framework,
            bundleId: "team.kuring.kuringlink",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "Satellite"),
                .external(name: "Cache"),
                .external(name: "Collections")
            ]
        ),
        .unitTests(name: "KuringLink")
    ]
)
