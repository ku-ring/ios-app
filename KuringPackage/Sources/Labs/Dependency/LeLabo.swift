import Foundation
import Dependencies

/// 쿠링랩 디펜던시. UserDefaults 에서 옵션 활성화 정보를 가져옵니다.
/// ```swift
/// @Dependency(\.leLabo) var leLabo
/// ```
public struct LeLabo {
    public var isBetaAEnabled: Bool
}

extension LeLabo {
    public static let `default` = LeLabo(
        isBetaAEnabled: (UserDefaults.standard.value(forKey: "lelabo/beta-a") as? Bool) ?? false
    )
}

extension LeLabo: DependencyKey {
    public static var liveValue = LeLabo.default
}

extension DependencyValues {
    public var leLabo: LeLabo {
        get { self[LeLabo.self] }
        set { self[LeLabo.self] = newValue }
    }
}
