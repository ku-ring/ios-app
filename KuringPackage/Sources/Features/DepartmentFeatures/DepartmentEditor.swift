import Models
import ComposableArchitecture

@Reducer
public struct DepartmentEditorFeature {
    @ObservableState
    public struct State: Equatable {
        public var myDepartments: IdentifiedArrayOf<NoticeProvider> = []
        public var results: IdentifiedArrayOf<NoticeProvider> = []
        
        public var searchText: String = ""
        public var focus: Field? = .search
        
        public var displayOption: Display = .myDepartment
        
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
            myDepartments: IdentifiedArrayOf<NoticeProvider> = [],
            results: IdentifiedArrayOf<NoticeProvider> = [],
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
                state.myDepartments.append(department)
                return .none
                
            case let .cancelAdditionButtonTapped(id: id):
                state.myDepartments.remove(id: id)
                return .none
                
            case let .deleteMyDepartmentButtonTapped(id: id):
                guard let department = state.myDepartments.first(where: { $0.id == id }) else {
                    return .none
                }
                state.alert = AlertState {
                    TextState("\(department.korName)를\n삭제하시겠습니까?")
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
                    TextState("모든 학과를 삭제하시겠습니까?")
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
                case let .confirmDelete(id: id):
                    state.myDepartments.remove(id: id)
                    return .none
                case .confirmDeleteAll:
                    state.myDepartments.removeAll()
                    return .none
                }
                
            case .alert(.dismiss):
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
    
    public init() { }
}
