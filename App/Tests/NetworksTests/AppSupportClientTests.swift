//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import XCTest
import Dependencies
@testable import Networks

@MainActor
final class AppSupportClientTests: XCTestCase {
    /// 실제 앱서비스에서 사용하는 `AppSupportClient.liveValue` 를 가지고 테스트 합니다.
    /// 예상 값: `true`
    func test_isAppVersionDeprecated_liveValue() async throws {
        @Dependency(\.appSupport) var appSupport
        let shouldUpdate = try await appSupport.isAppVersionDeprecated("1.9.0")
        XCTAssertTrue(shouldUpdate)
    }
    
    /// 현재 앱 버전이 최소 지원버전 보다 낮은 경우
    /// 예상 값: `true`
    func test_isAppVersionDeprecated_deprecated() async throws {
        let shouldUpdate = try await AppSupportClient.testValue.isAppVersionDeprecated("1.9.0")
        XCTAssertTrue(shouldUpdate)
    }
    
    /// 현재 앱 버전이 최소 지원버전 이상인 경우
    /// 예상 값: `false`
    func test_isAppVersionDeprecated_notDeprecated() async throws {
        let shouldUpdate = try await AppSupportClient.testValue.isAppVersionDeprecated("20.0.0")
        XCTAssertFalse(shouldUpdate)
    }
}
