//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import UIKit
import Dependencies

public enum KuringIcon: String, CaseIterable, Identifiable, Equatable {
    public var id: String { rawValue }
    case kuring_app
    case kuring_app_classic
    case kuring_app_blueprint
    case kuring_app_sketch

    public var korValue: String {
        switch self {
        case .kuring_app: return "쿠링 기본"
        case .kuring_app_classic: return "쿠링 클래식"
        case .kuring_app_blueprint: return "쿠링 블루프린트"
        case .kuring_app_sketch: return "쿠링 스케치"
        }
    }
}

public struct AppIcons: DependencyKey {
    public static let liveValue: AppIcons = .init(
        changeTo: { icon in
            guard UIApplication.shared.supportsAlternateIcons else { return }
            do {
                try await UIApplication.shared.setAlternateIconName(icon.rawValue)
            } catch {
                print(error.localizedDescription)
            }
        }
    )

    /// 현재 앱 아이콘
    public var currentAppIcon: KuringIcon {
        guard let iconName = UIApplication.shared.alternateIconName else {
            return .kuring_app
        }
        return KuringIcon(rawValue: iconName) ?? .kuring_app
    }

    /// 앱 아이콘을 변경합니다.
    /// - Important: 메인에서 돌아감.
    public var changeTo: @MainActor (KuringIcon) async -> Void
}

extension DependencyValues {
    public var appIcons: AppIcons {
        get { self[AppIcons.self] }
        set { self[AppIcons.self] = newValue }
    }
}
