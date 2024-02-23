//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import ComposableArchitecture

@Reducer
public struct DepartmentEditorFeature {
    @ObservableState
    public struct State: Equatable {
        public var myDepartments: IdentifiedArrayOf<NoticeProvider>
        public var results: IdentifiedArrayOf<NoticeProvider>

        public var searchText: String
        public var focus: Field?

        public var displayOption: Display

        public enum Field {
            case search
        }

        public enum Display: Hashable {
            /// 검색 결과 보여주기
            case searchResult
            /// 내 학과 보여주기
            case myDepartment
        }

        @Presents public var alert: AlertState<Action.Alert>?

        public init(
            myDepartments: IdentifiedArrayOf<NoticeProvider> = .init(
                uniqueElements: NoticeProvider.addedDepartments
            ),
            results: IdentifiedArrayOf<NoticeProvider> = .init(
                uniqueElements: NoticeProvider.departments
            ),
            searchText: String = "",
            focus: Field? = .search,
            displayOption: Display = .myDepartment,
            alert: AlertState<Action.Alert>? = nil
        ) {
            self.myDepartments = myDepartments
            self.results = results
            self.searchText = searchText
            self.focus = focus
            self.displayOption = displayOption
            self.alert = alert
        }
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)

        /// 학과 추가 버튼 눌렀을 때
        case addDepartmentButtonTapped(id: NoticeProvider.ID)
        /// 추가했던 학과 취소 버튼 눌렀을 때
        case cancelAdditionButtonTapped(id: NoticeProvider.ID)
        /// 내 학과 삭제 버튼 눌렀을 때
        case deleteMyDepartmentButtonTapped(id: NoticeProvider.ID)
        /// 내 학과 전체삭제 버튼 눌렀을 때
        case deleteAllMyDepartmentButtonTapped
        /// 텍스트 필드의 xmark를 눌렀을 때
        case clearTextFieldButtonTapped

        /// 알림 관련 액션
        case alert(PresentationAction<Alert>)
        /// 알림
        public enum Alert: Equatable {
            /// 개별 학과 추가 알림 시 추가 버튼 눌렀을 때
            case confirmAdd(department: NoticeProvider)
            /// 개별 학과 삭제 알림 시 삭제 버튼 눌렀을 때
            case confirmDelete(id: NoticeProvider.ID)
            /// 전체 삭제 알림 시 삭제 버튼 눌렀을 때
            case confirmDeleteAll
        }
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case let .addDepartmentButtonTapped(id: id):
                guard let department = state.results.first(where: { $0.id == id }) else {
                    return .none
                }
                guard !state.myDepartments.contains(department) else {
                    return .none
                }
                state.alert = AlertState {
                    TextState("\(department.korName)를\n내 학과 목록에 추가할까요?")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("취소하기")
                    }

                    ButtonState(
                        role: .destructive,
                        action: .confirmAdd(department: department)
                    ) {
                        TextState("추가하기")
                    }
                }
                return .none

            case let .deleteMyDepartmentButtonTapped(id: id), let .cancelAdditionButtonTapped(id: id):
                guard let department = state.myDepartments.first(where: { $0.id == id }) else {
                    return .none
                }
                state.alert = AlertState {
                    TextState("\(department.korName)를\n내 학과 목록에서 삭제할까요?")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("취소하기")
                    }

                    ButtonState(role: .destructive, action: .confirmDelete(id: id)) {
                        TextState("삭제하기")
                    }
                }
                return .none

            case .deleteAllMyDepartmentButtonTapped:
                state.alert = AlertState {
                    TextState("내 학과 목록을\n모두 삭제할까요?")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("취소하기")
                    }

                    ButtonState(role: .destructive, action: .confirmDeleteAll) {
                        TextState("삭제하기")
                    }
                }
                return .none

            case .clearTextFieldButtonTapped:
                state.searchText.removeAll()
                return .none

                // MARK: Alert

            case let .alert(.presented(alertAction)):
                switch alertAction {
                case let .confirmAdd(department: department):
                    state.myDepartments.append(department)
                    
                case let .confirmDelete(id: id):
                    state.myDepartments.remove(id: id)
                    
                case .confirmDeleteAll:
                    state.myDepartments.removeAll()
                }
                
                NoticeProvider.addedDepartments = state.myDepartments.elements
                return .none

            case .alert(.dismiss):
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }

    public init() { }
}
