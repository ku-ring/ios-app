import ProjectDescription

extension TargetDependency {
    public static func externalsrt(
        _ name: String
    ) -> TargetDependency {
        switch name {
        case "TCA":
            return .external(name: "ComposableArchitecture")
        default:
            return .external(name: name)
        }
    }
}
