import XCTest
import ComposableArchitecture
@testable import Labs

@MainActor
final class LabAppTests: XCTestCase {
    func test_selectBetaA() async throws {
        let store = TestStore(
            initialState: LabAppFeature.State(),
            reducer: { LabAppFeature() }
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
    }
}
