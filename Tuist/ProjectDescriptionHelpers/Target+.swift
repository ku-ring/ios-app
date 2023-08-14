import ProjectDescription

extension Target {
    public static func make(
        name: String,
        product: Product,
        bundleId: String,
        infoPlist: InfoPlist? = .default,
        sources: SourceFilesList,
        resources: ResourceFileElements? = nil,
        dependencies: [TargetDependency] = [],
        settings: Settings? = nil
    ) -> Target {        
        return Target(
            name: name,
            platform: .iOS,
            product: product,
            bundleId: bundleId,
            deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            dependencies: dependencies,
            settings: settings
        )
    }
    
    public static func unitTests(
        name: String,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return Target(
            name: "\(name)Tests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.kuring.\(name)Tests",
            deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: dependencies
        )
    }
}
