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
    public static func make(
        for type: TargetType,
        name: String,
        bundleId: String,
        dependencies: [TargetDependency] = [],
        needsExample: Bool = false
    ) -> Project {
        let target = makeTarget(
            for: type,
            name: name,
            bundleId: bundleId,
            dependencies: dependencies,
            needsExample: needsExample
        )
        
        return Project(
            name: name,
            targets: target
        )
    }
}

//MARK: - Target Factory
func makeTarget(
    for type: TargetType,
    name: String,
    bundleId: String,
    dependencies: [TargetDependency],
    needsExample: Bool = false
) -> [Target] {
    
    var targets: [Target] = []
    let defaultSettings = Settings.settings(
        configurations: [],
        defaultSettings: .recommended
    )
    
    let target = Target.target(
        name: "\(name)",
        destinations: Project.destinations,
        product: Project.resolvedProductType(),
        bundleId: "\(bundleId).\(name).\(type.rawValue)",
        deploymentTargets: Project.minDeploymentVersion,
        infoPlist: .default,
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        dependencies: dependencies,
        settings: defaultSettings
    )
    
    targets.append(target)
    
    if needsExample {
        let exampleTarget = Target.target(
            name: "\(name)Example",
            destinations: Project.destinations,
            product: .app,
            bundleId: "\(bundleId).\(name).example",
            deploymentTargets: Project.minDeploymentVersion,
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "\(name)Example",
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
        targets.append(exampleTarget)
    }

    return targets
}
