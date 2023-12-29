import XCTest
import ComposableArchitecture
@testable import Models
@testable import DepartmentFeatures
@testable import SubscriptionFeatures

@MainActor
class SubscriptionTests: XCTestCase {
    func test_tapConfirmButton() async throws {
        let dismissed = self.expectation(description: "dismissed")

        let store = TestStore(
            initialState: SubscriptionFeature.State(),
            reducer: { SubscriptionFeature() },
            withDependencies: {
                $0.dismiss = DismissEffect { dismissed.fulfill() }
            }
        )
        await store.send(.confirmButtonTapped) {
            $0.isWaitingResponse = true
        }
        
        await store.receive(.subscriptionResponse(true)) {
            $0.isWaitingResponse = false
        }
        
        await self.fulfillment(of: [dismissed])
    }
    
    func test_selectSegment() async throws {
        let store = TestStore(
            initialState: SubscriptionFeature.State(),
            reducer: { SubscriptionFeature() }
        )
        let university = SubscriptionFeature.State.SubscriptionType.university
        let department = SubscriptionFeature.State.SubscriptionType.department
        
        XCTAssertEqual(store.state.subscriptionType, .university)
        
        await store.send(.segmentSelected(department)) {
            $0.subscriptionType = .department
        }
        
        await store.send(.segmentSelected(university)) {
            $0.subscriptionType = .university
        }
    }
    
    func test_selectDepartment() async throws {
        let department = NoticeProvider(
            name: "computer_science",
            hostPrefix: "cse",
            korName: "컴퓨터공학부",
            category: .학과
        )
        let store = TestStore(
            initialState: SubscriptionFeature.State(myDepartments: [department]),
            reducer: { SubscriptionFeature() }
        )
        
        // 학과 선택
        await store.send(.departmentSelected(department)) {
            $0.selectedDepartment = [department]
        }
        // 학과 선택 해지
        await store.send(.departmentSelected(department)) {
            $0.selectedDepartment = []
        }
    }
}
