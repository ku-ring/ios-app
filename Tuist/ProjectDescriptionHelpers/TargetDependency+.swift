import ProjectDescription

extension TargetDependency {
    public static func externalsrt(
        _ name: String
    ) -> TargetDependency {
        switch name {
        case "TCA":
            return .external(name: "ComposableArchitecture")
        case "Satellite":
            return .external(name: "Satellite")
        default:
            return .external(name: name)
        }
    }
}
