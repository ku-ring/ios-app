@preconcurrency import ProjectDescription

public let bundleId_release = "com.kuring.service"
public let bundleId_debug = "com.kuring.service.debug"

extension Project {
    
    public static let destinations: ProjectDescription.Destinations = [.iPhone, .iPad]
    
    public static let minDeploymentVersion: DeploymentTargets = .iOS("17.0")
    
    public static func resolvedProductType() -> ProjectDescription.Product {
        if Environment.isDynamic.getBoolean(default: false) {
            return .framework
        } else {
            return .staticFramework
        }
    }
    
    // MARK: - Project Factory
    public static func cache(
        name: String,
        bundleId: String,
        dependencies: [TargetDependency] = []
    ) -> Project {
        let target = makeCacheTarget(
            name: name,
            bundleId: bundleId,
            dependencies: dependencies
        )
        
        return Project(
            name: name,
            targets: [target]
        )
    }
    
    public static func feature(
        name: String,
        bundleId: String,
        dependencies: [TargetDependency] = []
    ) -> Project {
        let target = makeFeatureTarget(
            name: name,
            bundleId: bundleId,
            dependencies: dependencies
        )
        
        return Project(
            name: name,
            targets: [target]
        )
    }
    
    public static func lab(
        name: String,
        bundleId: String,
        dependencies: [TargetDependency] = []
    ) -> Project {
        let target = makeFeatureTarget(
            name: name,
            bundleId: bundleId,
            dependencies: dependencies
        )
        
        return Project(
            name: name,
            targets: [target]
        )
    }
    
    public static func model(
        name: String,
        bundleId: String,
        dependencies: [TargetDependency] = []
    ) -> Project {
        let target = makeModelTargets(
            name: name,
            bundleId: bundleId,
            dependencies: dependencies
        )
        
        return Project(
            name: name,
            targets: [target]
        )
    }
    
    public static func network(
        name: String,
        bundleId: String,
        dependencies: [TargetDependency] = []
    ) -> Project {
        let target = makeNetworkTarget(
            name: name,
            bundleId: bundleId,
            dependencies: dependencies
        )
        
        return Project(
            name: name,
            targets: [target]
        )
    }
    
    public static func pushNotifications(
        name: String,
        bundleId: String,
        dependencies: [TargetDependency] = []
    ) -> Project {
        let target = makePushNotificationsTarget(
            name: name,
            bundleId: bundleId,
            dependencies: dependencies
        )
        
        return Project(
            name: name,
            targets: [target]
        )
    }
    
    public static func ui(
        name: String,
        bundleId: String,
        dependencies: [TargetDependency] = []
    ) -> Project {
        let targets = makeUITarget(
            name: name,
            bundleId: bundleId,
            dependencies: dependencies
        )
        
        return Project(
            name: name,
            targets: targets
        )
    }
}

//MARK: - Target Factory
func makeCacheTarget(
    name: String,
    bundleId: String,
    dependencies: [TargetDependency]
) -> Target {
    
    let defaultSettings = Settings.settings(
        configurations: [],
        defaultSettings: .recommended
    )
    
    let cachesTarget = Target.target(
        name: "\(name)",
        destinations: Project.destinations,
        product: Project.resolvedProductType(),
        bundleId: "\(bundleId).\(name).cache",
        deploymentTargets: Project.minDeploymentVersion,
        infoPlist: .default,
        sources: ["Sources/**"],
        dependencies: dependencies,
        settings: defaultSettings
    )
    
    return cachesTarget
}

func makeFeatureTarget(
    name: String,
    bundleId: String,
    dependencies: [TargetDependency]
) -> Target {
    
    let defaultSettings = Settings.settings(
        configurations: [],
        defaultSettings: .recommended
    )
    
    let featureTarget = Target.target(
        name: "\(name)",
        destinations: Project.destinations,
        product: Project.resolvedProductType(),
        bundleId: "\(bundleId).\(name).feature",
        deploymentTargets: Project.minDeploymentVersion,
        infoPlist: .default,
        sources: ["Sources/**"],
        dependencies: dependencies,
        settings: defaultSettings
    )
    
    return featureTarget
}

func makeLabTarget(
    name: String,
    bundleId: String,
    dependencies: [TargetDependency]
) -> Target {
    
    let defaultSettings = Settings.settings(
        configurations: [],
        defaultSettings: .recommended
    )
    
    let labTarget = Target.target(
        name: "\(name)",
        destinations: Project.destinations,
        product: Project.resolvedProductType(),
        bundleId: "\(bundleId).\(name).lab",
        deploymentTargets: Project.minDeploymentVersion,
        infoPlist: .default,
        sources: ["Sources/**"],
        dependencies: dependencies,
        settings: defaultSettings
    )
    
    return labTarget
}

func makeModelTargets(
    name: String,
    bundleId: String,
    dependencies: [TargetDependency]
) -> Target {
    
    let defaultSettings = Settings.settings(
        configurations: [],
        defaultSettings: .recommended
    )
    
    let modelsTarget = Target.target(
        name: "\(name)",
        destinations: Project.destinations,
        product: Project.resolvedProductType(),
        bundleId: "\(bundleId).\(name).models",
        deploymentTargets: Project.minDeploymentVersion,
        infoPlist: .default,
        sources: ["Sources/**"],
        dependencies: dependencies,
        settings: defaultSettings
    )
    
    return modelsTarget
}


func makeNetworkTarget(
    name: String,
    bundleId: String,
    dependencies: [TargetDependency]
) -> Target {
    
    let defaultSettings = Settings.settings(
        configurations: [],
        defaultSettings: .recommended
    )
    
    let networkTarget = Target.target(
        name: "\(name)",
        destinations: Project.destinations,
        product: Project.resolvedProductType(),
        bundleId: "\(bundleId).\(name).models",
        deploymentTargets: Project.minDeploymentVersion,
        infoPlist: .default,
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        dependencies: dependencies,
        settings: defaultSettings
    )
    
    return networkTarget
}

func makePushNotificationsTarget(
    name: String,
    bundleId: String,
    dependencies: [TargetDependency]
) -> Target {
    
    let defaultSettings = Settings.settings(
        configurations: [],
        defaultSettings: .recommended
    )
    
    let pushNotificationsTarget = Target.target(
        name: "\(name)",
        destinations: Project.destinations,
        product: Project.resolvedProductType(),
        bundleId: "\(bundleId).\(name).pushNotification",
        deploymentTargets: Project.minDeploymentVersion,
        infoPlist: .default,
        sources: ["Sources/**"],
        dependencies: dependencies,
        settings: defaultSettings
    )
    
    return pushNotificationsTarget
}

func makeUITarget(
    name: String,
    bundleId: String,
    dependencies: [TargetDependency]
) -> [Target] {
    
    let defaultSettings = Settings.settings(
        configurations: [],
        defaultSettings: .recommended
    )
    
    let uiTarget = Target.target(
        name: "\(name)",
        destinations: Project.destinations,
        product: Project.resolvedProductType(),
        bundleId: "\(bundleId).\(name).ui",
        deploymentTargets: Project.minDeploymentVersion,
        infoPlist: .default,
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        dependencies: dependencies,
        settings: defaultSettings
    )
    
    let exampleTarget = Target.target(
        name: "\(name)Example",
        destinations: Project.destinations,
        product: .app,
        bundleId: "\(bundleId).\(name).ui",
        deploymentTargets: Project.minDeploymentVersion,
        infoPlist: .extendingDefault(with: [
            "CFBundleDisplayName": "\(name)",
            "CFBundleShortVersionString": "1.0.0",
            "CFBundleVersion": "1",
            "UILaunchStoryboardName": "LaunchScreen"
        ]),
        sources: ["Example/**"],
        dependencies: [
            .target(name: name)
        ],
        settings: defaultSettings
    )
    
    return [
        uiTarget,
        exampleTarget
    ]
}
