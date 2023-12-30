import Foundation
import Dependencies

/// 쿠링랩 디펜던시. UserDefaults 에서 옵션 활성화 정보를 가져옵니다.
/// ```swift
/// @Dependency(\.leLabo) var leLabo
/// ```
public struct LeLabo {
    public typealias NewValue = Bool
    
    public enum Experiment: String, Equatable {
        case betaA = "beta-a"
        
        var key: String {
            let baseKey = "com.kuring.service.lelabo.experiments"
            return "\(baseKey).\(self.rawValue)"
        }
    }
    
    public var status: (Experiment) -> Bool
    public var set: (NewValue, Experiment) -> Void
}

extension LeLabo {
    public static let `default` = LeLabo(
        status: { experiment in
            let value = UserDefaults.standard.value(forKey: experiment.key) as? Bool
            return value ?? false
        },
        set: { newValue, experiment in
            UserDefaults.standard.set(newValue, forKey: experiment.key)
        }
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
