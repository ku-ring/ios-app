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
                .externalsrt("Satellite")
            ]
        ),
        .unitTests(name: "KuringLink")
    ]
)
