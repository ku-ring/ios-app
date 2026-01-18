@preconcurrency import ProjectDescription

extension Target {
    public static let kuringAppDebug: Target = .target(
        name: "KuringApp_Debug",
        destinations: .iOS,
        product: .app,
        bundleId: bundleId_debug,
        deploymentTargets: .iOS("17.0"),
        infoPlist: .extendingDefault(
            with: [
                "FirebaseAppDelegateProxyEnabled": .boolean(false),
                "ITSAppUsesNonExemptEncryption": .boolean(false),
                "NSAppTransportSecurity": [
                    "NSAllowsArbitraryLoads": .boolean(true)
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
                "UIDesignRequiresCompatibility": .boolean(true),
                "CFBundleDisplayName": "쿠링(Debug)",
                "CFBundleShortVersionString": "2.4.1",
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
            .project(target: "PushNotifications", path: "../Shared/PushNotifications"),
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
                "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon_Debug"
            ],
            configurations: [
                .debug(
                    name: "Debug",
                    settings: SettingsDictionary()
                        .automaticCodeSigning(devTeam: "6DXT245L5T")
                        .swiftActiveCompilationConditions(["DEBUG"])
                        .otherLinkerFlags(["-all_load -Objc"])
                        .swiftVersion("5.9")
                        .bitcodeEnabled(false),
                    xcconfig: "Configurations/Debug.xcconfig"
                )
            ]
        )
    )
}
