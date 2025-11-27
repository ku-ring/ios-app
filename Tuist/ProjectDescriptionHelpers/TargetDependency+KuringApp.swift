@preconcurrency import ProjectDescription

extension TargetDependency {
    
    public static func ui(_ name: String) -> TargetDependency {
        .project(target: name, path: "../UIKit/\(name)")
    }
    
    public static func feature(_ name: String) -> TargetDependency {
        .project(target: "\(name)", path: "../Features/\(name)")
    }
}

