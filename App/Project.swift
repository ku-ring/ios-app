import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "KuringApp",
    settings: .settings(
        base: SettingsDictionary()
            .codeSignIdentityAppleDevelopment()
            .automaticCodeSigning(devTeam: "6DXT245L5T")
            .swiftVersion("5.0")
            .otherLinkerFlags(["-all_load -Objc"])
            .bitcodeEnabled(false),
        configurations: [
            .debug(name: "Debug"),
            .release(name: "Release")
        ]
    ),
    targets: [
        .kuringApp,
        .kuringAppDebug,
        .kuringTests
    ],
    schemes: [
        .scheme(
            name: "KuringApp",
            shared: true,
            buildAction: .buildAction(targets: ["KuringApp"]),
            runAction: .runAction(configuration: .release),
            archiveAction: .archiveAction(configuration: .release)
        ),
        .scheme(
            name: "KuringApp(Debug)",
            shared: true,
            buildAction: .buildAction(targets: ["KuringApp(Debug)"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug)
        ),
        .scheme(
            name: "KuringTests",
            buildAction: .buildAction(targets: ["KuringTests"])
        )
    ]
)
