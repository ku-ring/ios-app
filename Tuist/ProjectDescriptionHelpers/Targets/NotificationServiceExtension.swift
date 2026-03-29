@preconcurrency import ProjectDescription

extension Target {
    public static let notificationServiceExtension: Target = .target(
        name: "NotificationServiceExtension",
        destinations: .iOS,
        product: .appExtension,
        bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER)",
        deploymentTargets: .iOS("17.0"),
        infoPlist: .extendingDefault(with: [
            "CFBundleDisplayName": "$(PRODUCT_NAME)",
            "NSExtension": [
                "NSExtensionPointIdentifier": "com.apple.usernotifications.service",
                "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).NotificationService",
            ],
        ]),
        sources: [
            .glob(.relativeToRoot("App/KuringNotificationService/**"))
        ],
        entitlements: .variable("CODE_SIGN_ENTITLEMENTS"),
        dependencies: [
            .external(name: "Dependencies"),
            .project(target: "Caches", path: "../Shared/Caches"),
            .project(target: "Models", path: "../Shared/Models"),
            .project(target: "PushNotifications", path: "../Shared/PushNotifications"),
            
        ],
        settings: .settings(
            base: SettingsDictionary()
                .automaticCodeSigning(devTeam: "6DXT245L5T")
                .swiftVersion("5.9"),
            configurations: [
                .debug(
                    name: "Debug",
                    settings: [
                        "PRODUCT_BUNDLE_IDENTIFIER": "com.kuring.service.debug.KuringNotificationService",
                        "CODE_SIGN_ENTITLEMENTS": "KuringNotificationService/NotificationServiceDebug.entitlements",
                        "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG"
                    ]
                ),
                .release(
                    name: "Release",
                    settings: [
                        "PRODUCT_BUNDLE_IDENTIFIER": "com.kuring.service.KuringNotificationService",
                        "CODE_SIGN_ENTITLEMENTS": "KuringNotificationService/NotificationService.entitlements",
                        "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "RELEASE"
                    ]
                )
            ]
        )
    )
}
