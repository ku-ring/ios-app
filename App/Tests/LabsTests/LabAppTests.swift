//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import XCTest
import ComposableArchitecture
@testable import Labs

@MainActor
final class LabAppTests: XCTestCase {
    func test_selectBetaA() async throws {
        let leLabo = LeLabo.testValue
        let store = TestStore(
            initialState: LabAppFeature.State(),
            reducer: { LabAppFeature() },
            withDependencies: { $0.leLabo = leLabo }
        )
        let betaAStateForPath = LabAppFeature.Path.State.betaA(
            BetaADetailFeature.State()
        )

        /// 스택 네비게이션 동작
        await store.send(.path(.push(id: 0, state: betaAStateForPath))) {
            $0.path[id: 0] = betaAStateForPath
            $0.path[id: 0, case: \.betaA]?.isEnabled = false
        }

        /// 베타A 기능 활성화
        await store.send(.path(.element(id: 0, action: .betaA(.binding(.set(\.isEnabled, true)))))) {
            $0.path[id: 0, case: \.betaA]?.isEnabled = true
        }

        /// 디펜던시에 값이 업데이트 되었는지 확인
        withDependencies {
            $0.leLabo = leLabo
        } operation: {
            XCTAssertEqual(leLabo.status(.betaA), true)
        }
    }
}
