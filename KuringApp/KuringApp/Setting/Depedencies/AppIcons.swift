//
//  AppIcons.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/10/06.
//

import UIKit
import ComposableArchitecture

public struct AppIcons: DependencyKey {
    public static let liveValue: AppIcons  = AppIcons(
        changeTo: { icon in
            guard UIApplication.shared.supportsAlternateIcons else { return }
            do {
                try await UIApplication.shared.setAlternateIconName(icon.rawValue)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    )
    
    /// 현재 앱 아이콘
    var currentAppIcon: KuringIcon {
        guard let iconName = UIApplication.shared.alternateIconName else {
            return .kuring_app
        }
        return KuringIcon(rawValue: iconName) ?? .kuring_app
    }
    
    /// 앱 아이콘을 변경합니다.
    /// - Important: 메인에서 돌아감.
    var changeTo: @MainActor (KuringIcon) async -> Void
}

extension DependencyValues {
    public var appIcons: AppIcons {
        get { self[AppIcons.self] }
        set { self[AppIcons.self] = newValue }
    }
}
