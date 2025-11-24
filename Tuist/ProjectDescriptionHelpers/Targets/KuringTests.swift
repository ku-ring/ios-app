@preconcurrency import ProjectDescription

extension Target {
    public static let kuringTests: Target = .target(
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
            .project(target: "Caches", path: "../Shared/Caches"),
            .project(target: "Models", path: "../Shared/Models"),
            .project(target: "Networks", path: "../Shared/Networks"),
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
}
