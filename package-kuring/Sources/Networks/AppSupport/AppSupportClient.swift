//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

public typealias AppVersion = String

public struct AppSupportClient {
    // MARK: - App Minimum Version
    
    /// 현재 앱 버전이 만료되었는지 확인합니다.
    /// - Important: `.versionUpdateAlert()` view modifier 를 사용하여 업데이트 권장 알림을 띄울 수 있습니다.
    /// - Note: 쿠링 앱의 최소 지원버전을 가져와서 비교합니다.
    /// ```swift
    /// let client = AppSupportClient()
    /// let showsUpdateAlert = try await client.isAppVersionDeprecated()
    /// ```
    ///
    /// ```swift
    /// MyView()
    ///     // `isAppVersionDeprecated()` 값이 
    ///     // `true` 면 업데이트 권장 알림 띄움
    ///     .versionUpdateAlert()
    /// ```
    public var isAppVersionDeprecated: (AppVersion?) async throws -> Bool
}
