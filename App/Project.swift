import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "KuringApp",
    options: .options(
        automaticSchemesOptions: .disabled,
        disableBundleAccessors: true,
        disableShowEnvironmentVarsInScriptPhases: true,
        disableSynthesizedResourceAccessors: true
    ),
    settings: .settings(
        base: [
            "ENABLE_MODULE_VERIFIER": "YES",
            "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
            "ENABLE_GENERATED_ASSET_SYMBOL_EXTENSIONS": "YES"
        ],
        configurations: [
            .debug(name: "Debug"),
            .release(name: "Release")
        ],
        defaultSettings: .recommended
    ),
    targets: [
        .kuringApp,
        .kuringAppDebug,
        .kuringTests,
        .notificationServiceExtension
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
            name: "KuringApp_Debug",
            shared: true,
            buildAction: .buildAction(targets: ["KuringApp_Debug"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug)
        ),
        .scheme(
            name: "KuringTests",
            buildAction: .buildAction(targets: ["KuringTests"])
        )
    ]
)
