//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    /// ```swift
    /// @Dependency(\.appSupport) var appSupport
    /// let showsUpdateAlert = try await appSupport.isAppVersionDeprecated()
    /// ```
    public var appSupport: AppSupportClient {
        get { self[AppSupportClient.self] }
        set { self[AppSupportClient.self] = newValue }
    }
}

extension AppSupportClient: DependencyKey {
    public static var liveValue = AppSupportClient(
        isAppVersionDeprecated: { appVersion in
            guard let url = URL(string: "https://raw.githubusercontent.com/ku-ring/space/main/app-versions/ios.json") else {
                return false
            }
            let (data, response) = try await URLSession.shared.data(from: url)
            let minVersion = try JSONDecoder().decode(AppSupport.self, from: data)
            let minVersionInfos = minVersion.minimumVersion
                .components(separatedBy: ".")
                .map { Int($0) }
            let appVersionInfos = (appVersion ?? KuringLink.appVersion)
                .components(separatedBy: ".")
                .map { Int($0) }
            
            let appMajorVersion = appVersionInfos[0] ?? 0
            let appMinorVersion = appVersionInfos[1] ?? 0
            let appPatchVersion = appVersionInfos[2] ?? 0
            
            let minMajorVersion = minVersionInfos[0] ?? 0
            let minMinorVersion = minVersionInfos[1] ?? 0
            let minPatchVersion = minVersionInfos[2] ?? 0
            
            // 메이저 버전 비교
            // 3. 최소버전과 동일시 마이너 버전 체크
            guard appMajorVersion == minMajorVersion else {
                // 1. 최소버전 보다 작으면 만료이므로 즉각 리턴 `true`
                // 2. 최소버전 보다 크면 만료가 아니므로 즉각 리턴 `false`
                return appMajorVersion < minMajorVersion
            }
            
            // 마이너 버전 비교
            // 3. 최소버전과 동일시 패치 버전 체크
            guard appMinorVersion == minMinorVersion else {
                // 1. 최소버전 보다 작으면 만료이므로 즉각 리턴 `true`
                // 2. 최소버전 보다 크면 만료가 아니므로 즉각 리턴 `false`
                return appMinorVersion < minMinorVersion
            }
            
            // 최소버전 보다 작으면 만료이므로 즉각 리턴 `true`
            return appPatchVersion < minPatchVersion
        }
    )
}

extension AppSupportClient {
    public static var testValue = AppSupportClient(
        isAppVersionDeprecated: { appVersion in
            let minVersion = "2.0.0"
            let minVersionInfos = minVersion
                .components(separatedBy: ".")
                .map { Int($0) }
            
            let appVersionInfos = (appVersion ?? KuringLink.appVersion)
                .components(separatedBy: ".")
                .map { Int($0) }
            
            let appMajorVersion = appVersionInfos[0] ?? 0
            let appMinorVersion = appVersionInfos[1] ?? 0
            let appPatchVersion = appVersionInfos[2] ?? 0
            
            let minMajorVersion = minVersionInfos[0] ?? 0
            let minMinorVersion = minVersionInfos[1] ?? 0
            let minPatchVersion = minVersionInfos[2] ?? 0
            
            guard appMajorVersion == minMajorVersion else {
                return appMajorVersion < minMajorVersion
            }
            
            guard appMinorVersion == minMinorVersion else {
                return appMinorVersion < minMinorVersion
            }
            return appPatchVersion < minPatchVersion
        }
    )
}
