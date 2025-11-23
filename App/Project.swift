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
        .target(
            name: "KuringApp",
            destinations: .iOS,
            product: .app,
            bundleId: bundleId_release,
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "FirebaseAppDelegateProxyEnabled": .boolean(false),
                    "ITSAppUsesNonExemptEncryption": .boolean(false),
                    "NSAppTransportSecurity": [
                        "NSAppTransportSecurity": .boolean(true)
                    ],
                    "UIBackgroundModes": [
                        "remote-notification"
                    ],
                    "UILaunchScreen": [
                        "UIImageName": "kuring.logo",
                        "UIImageRespectsSafeAreaInsets": .boolean(true)
                    ],
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait"
                    ],
                    "UISupportedInterfaceOrientations~ipad": [
                        "UIInterfaceOrientationPortrait",
                        "UIInterfaceOrientationPortraitUpsideDown",
                        "UIInterfaceOrientationLandscapeLeft",
                        "UIInterfaceOrientationLandscapeRight"
                    ],
                    "CFBundleDisplayName": "쿠링",
                    "CFBundleShortVersionString": "2.3.5",
                    "CFBundleVersion": "1",
                ]
            ),
            sources: ["Sources/**"],
            resources: [
                "Resources/**",
                "Configurations/**"
            ],
            entitlements: "KuringApp.entitlements",
            dependencies: [
                .external(name: "FirebaseMessaging"),
                .project(target: "PushNotifications", path: "../PushNotifications"),
                .ui("BotUI"),
                .ui("NoticeUI"),
                .ui("SubscriptionUI"),
                .ui("DepartmentUI"),
                .ui("SearchUI"),
                .ui("SettingsUI"),
                .ui("CampusUI"),
                .ui("CommonUI"),
                .ui("OnboardingUI"),
                .ui("LoginUI"),
                .ui("AcademicCalendarUI")
            ],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_ALTERNATE_APPICON_NAMES": "AppIcon-kuring-app.jpg AppIcon-kuring-app-classic AppIcon-kuring-app-sketch AppIcon-kuring-app-blueprint",
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                ],
                configurations: [
                    .release(
                        name: "Release",
                        settings: SettingsDictionary()
                            .codeSignIdentityAppleDevelopment()
                            .automaticCodeSigning(devTeam: "6DXT245L5T")
                            .swiftActiveCompilationConditions([])
                            .swiftVersion("5.0")
                            .bitcodeEnabled(false),
                        xcconfig: "Configurations/Release.xcconfig"
                    )
                ]
            )
        ),
        .target(
            name: "KuringApp(Debug)",
            destinations: .iOS,
            product: .app,
            bundleId: bundleId_debug,
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "FirebaseAppDelegateProxyEnabled": .boolean(false),
                    "ITSAppUsesNonExemptEncryption": .boolean(false),
                    "NSAppTransportSecurity": [
                        "NSAppTransportSecurity": .boolean(true)
                    ],
                    "UIBackgroundModes": [
                        "remote-notification"
                    ],
                    "UILaunchScreen": [
                        "UIImageName": "kuring.logo",
                        "UIImageRespectsSafeAreaInsets": .boolean(true)
                    ],
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait"
                    ],
                    "UISupportedInterfaceOrientations~ipad": [
                        "UIInterfaceOrientationPortrait",
                        "UIInterfaceOrientationPortraitUpsideDown",
                        "UIInterfaceOrientationLandscapeLeft",
                        "UIInterfaceOrientationLandscapeRight"
                    ],
                    "CFBundleDisplayName": "쿠링(Debug)",
                    "CFBundleShortVersionString": "2.3.5",
                    "CFBundleVersion": "1",
                ]
            ),
            sources: ["Sources/**"],
            resources: [
                "Resources/**",
                "Configurations/**"
            ],
            entitlements: "KuringApp.entitlements",
            dependencies: [
                .external(name: "FirebaseMessaging"),
                .project(target: "PushNotifications", path: "../PushNotifications"),
                .ui("BotUI"),
                .ui("NoticeUI"),
                .ui("SubscriptionUI"),
                .ui("DepartmentUI"),
                .ui("SearchUI"),
                .ui("SettingsUI"),
                .ui("CampusUI"),
                .ui("CommonUI"),
                .ui("OnboardingUI"),
                .ui("LoginUI"),
                .ui("AcademicCalendarUI")
            ],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_ALTERNATE_APPICON_NAMES": "AppIcon-kuring-app.jpg AppIcon-kuring-app-classic AppIcon-kuring-app-sketch AppIcon-kuring-app-blueprint",
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon_Debug",
                ],
                configurations: [
                    .debug(
                        name: "Debug",
                        settings: SettingsDictionary()
                            .codeSignIdentityAppleDevelopment()
                            .automaticCodeSigning(devTeam: "6DXT245L5T")
                            .swiftActiveCompilationConditions(["DEBUG"])
                            .swiftVersion("5.0")
                            .bitcodeEnabled(false),
                        xcconfig: "Configurations/Debug.xcconfig"
                    )
                ]
            )
        ),
        .target(
            name: "KuringTests",
            destinations: .iOS,
            product: .unitTests,
            productName: "KuringTests",
            bundleId: "\(bundleId_release).tests",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .external(name: "ActivityUI"),
                .external(name: "Dependencies"),
                .external(name: "ComposableArchitecture"),
                .project(target: "Labs", path: "../Labs"),
                .project(target: "Caches", path: "../Caches"),
                .project(target: "Models", path: "../Models"),
                .project(target: "Networks", path: "../Networks"),
                .feature("NoticeFeatures"),
                .feature("SearchFeatures"),
                .feature("SubscriptionFeatures"),
            ],
            settings: .settings(
                base: SettingsDictionary()
                    .codeSignIdentityAppleDevelopment()
                    .automaticCodeSigning(devTeam: "6DXT245L5T"),
                configurations: [],
                defaultSettings: .recommended
            )
        )
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
