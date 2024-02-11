//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import XCTest
import ComposableArchitecture
@testable import Models
@testable import DepartmentFeatures
@testable import SubscriptionFeatures

@MainActor
class SubscriptionAppTests: XCTestCase {
    func test_showDepartmentEditor() async throws {
        let 컴퓨터공학부 = NoticeProvider(
            name: "computer_science",
            hostPrefix: "cse",
            korName: "컴퓨터공학부",
            category: .학과
        )
        let 체육교육과 = NoticeProvider(
            name: "physical_education",
            hostPrefix: "kupe",
            korName: "체육교육과",
            category: .학과
        )

        let store = TestStore(
            initialState: SubscriptionAppFeature.State(
                root: SubscriptionFeature.State(myDepartments: [컴퓨터공학부])
            ),
            reducer: { SubscriptionAppFeature() }
        )
        // 푸시 액션
        let departmentEditorState: SubscriptionAppFeature.Path.State = .departmentEditor(
            DepartmentEditorFeature.State(myDepartments: [컴퓨터공학부], results: [체육교육과])
        )
        await store.send(.path(.push(id: 0, state: departmentEditorState))) {
            $0.path[id: 0] = departmentEditorState
        }

        await store.send(
            .path(
                .element(
                    id: 0,
                    action: .departmentEditor(.deleteMyDepartmentButtonTapped(id: 컴퓨터공학부.id))
                )
            )
        ) {
            $0.path[id: 0, case: /SubscriptionAppFeature.Path.State.departmentEditor]?.alert = AlertState {
                TextState("\(컴퓨터공학부.korName)를\n내 학과 목록에서 삭제할까요?")
            } actions: {
                ButtonState(role: .cancel) {
                    TextState("취소하기")
                }

                ButtonState(role: .destructive, action: .confirmDelete(id: 컴퓨터공학부.id)) {
                    TextState("삭제하기")
                }
            }
        }

        await store.send(
            .path(
                .element(
                    id: 0,
                    action: .departmentEditor(.alert(.presented(.confirmDelete(id: 컴퓨터공학부.id))))
                )
            )
        ) {
            $0.path[id: 0, case: /SubscriptionAppFeature.Path.State.departmentEditor]?.alert = nil
            $0.path[id: 0, case: /SubscriptionAppFeature.Path.State.departmentEditor]?.myDepartments = []
        }

        await store.send(
            .path(
                .element(
                    id: 0,
                    action: .departmentEditor(.addDepartmentButtonTapped(id: 체육교육과.id))
                )
            )
        ) {
            $0.path[id: 0, case: /SubscriptionAppFeature.Path.State.departmentEditor]?.alert = AlertState {
                TextState("\(체육교육과.korName)를\n내 학과 목록에 추가할까요?")
            } actions: {
                ButtonState(role: .cancel) {
                    TextState("취소하기")
                }
                
                ButtonState(
                    role: .destructive,
                    action: .confirmAdd(department: 체육교육과)
                ) {
                    TextState("추가하기")
                }
            }
        }
        
        // 사용자가 ok 버튼을 눌렀을 때
        await store.send(
            .path(
                .element(
                    id: 0,
                    action: .departmentEditor(.alert(.presented(.confirmAdd(department: 체육교육과))))
                )
            )
        ) {
            $0.path[id: 0, case: /SubscriptionAppFeature.Path.State.departmentEditor]?.alert = nil
            $0.path[id: 0, case: /SubscriptionAppFeature.Path.State.departmentEditor]?.myDepartments = [체육교육과]
        }
        
        await store.send(.path(.popFrom(id: 0))) {
            $0.path = .init()
            $0.subscriptionView.myDepartments = [체육교육과]
        }
    }
}
