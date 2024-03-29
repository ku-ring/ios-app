//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import Caches
import ComposableArchitecture

@Reducer
public struct DepartmentEditorFeature {
    @ObservableState
    public struct State: Equatable {
        /// 내가 선택한 학과
        public var myDepartments: IdentifiedArrayOf<NoticeProvider>
        /// 모든학과
        public var allDepartments: IdentifiedArrayOf<NoticeProvider>
        /// 검색결과
        public var searchResults: IdentifiedArrayOf<NoticeProvider>
        
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
            @Dependency(\.departments) var departments
            
            self.myDepartments = IdentifiedArrayOf(uniqueElements: departments.getAll())
            self.searchResults = []
            self.allDepartments = results
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
        
        /// 검색 문자열 변경
        case searchQueryChanged(String)

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
        
        /// 델리게이트
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case addedDepartmentsUpdated
        }
    }

    @Dependency(\.departments) var departments
    
    private var engine: DepartmentSearchEngine = DepartmentSearchEngineImpl()
    
    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case let .addDepartmentButtonTapped(id: id):
                guard let department = state.searchResults.first(where: { $0.id == id }) else {
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
                    departments.add(department)
                    
                case let .confirmDelete(id: id):
                    state.myDepartments.remove(id: id)
                    departments.remove(id)
                    
                case .confirmDeleteAll:
                    state.myDepartments.removeAll()
                    departments.removeAll()
                }
                NoticeProvider.addedDepartments = state.myDepartments.elements
                return .none
                
            case let .searchQueryChanged(query):
                state.searchText = query

                if !state.searchText.isEmpty {
                    state.searchResults = engine.search(
                        keyword: query,
                        allDepartments: state.allDepartments
                    )
                }
                return .none

            case .alert(.dismiss):
                return .none
                
                // MARK: Delegate
                
            case .delegate:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .onChange(of: \.myDepartments) { oldValue, newValue in
            Reduce { state, _ in
                return .send(.delegate(.addedDepartmentsUpdated))
            }
        }
    }

    public init() { }
}
