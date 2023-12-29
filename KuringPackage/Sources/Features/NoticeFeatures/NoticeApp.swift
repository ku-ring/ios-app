import Models
import DepartmentFeatures
import SubscriptionFeatures
import ComposableArchitecture

@Reducer
public struct NoticeAppFeature {
    @ObservableState
    public struct State: Equatable {
        // MARK: 네비게이션
        
        /// 루트
        public var noticeList = NoticeListFeature.State()
        /// 스택 네비게이션
        public var path = StackState<Path.State>()
        /// 트리 네비게이션 - ``SubscriptionAppFeature``
        @Presents public var changeSubscription: SubscriptionAppFeature.State?
        
        public init(
            noticeList: NoticeListFeature.State = NoticeListFeature.State(),
            path: StackState<Path.State> = StackState<Path.State>(),
            changeSubscription: SubscriptionAppFeature.State? = nil
        ) {
            self.noticeList = noticeList
            self.path = path
            self.changeSubscription = changeSubscription
        }
    }
    
    public enum Action {
        /// 루트(``NoticeListFeature``) 액션
        case noticeList(NoticeListFeature.Action)
        
        /// 스택 네비게이션 액션 (``NoticeAppFeature/Path``)
        case path(StackAction<Path.State, Path.Action>)
        
        /// 구독 변경 버튼을 탭한 경우
        case changeSubscriptionButtonTapped
        
        /// ``SubscriptionAppFeature`` 의 Presentation 액션
        case changeSubscription(PresentationAction<SubscriptionAppFeature.Action>)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.noticeList, action: \.noticeList) {
            NoticeListFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .path:
                return .none
                
            case let .noticeList(.delegate(delegate)):
                switch delegate {
                case .editDepartment:
                    state.path.removeAll()
                    state.path.append(
                        Path.State.departmentEditor(
                            // TODO: init parameter 수정 (현재는 테스트용)
                            DepartmentEditorFeature.State(
                                myDepartments: IdentifiedArray(uniqueElements: NoticeProvider.departments),
                                results: IdentifiedArray(uniqueElements: NoticeProvider.departments)
                            )
                        )
                    )
                    return .none
                }
                
            case .changeSubscription(.presented(.subscriptionView(.subscriptionResponse))):
                /// ``SubscriptionAppFeature`` 액션
                state.changeSubscription = nil
                return .none
                
            case .changeSubscriptionButtonTapped:
                state.changeSubscription = SubscriptionAppFeature.State()
                return .none
                
            case .noticeList, .changeSubscription:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
        .ifLet(\.$changeSubscription, action: \.changeSubscription) {
            SubscriptionAppFeature()
        }
    }
    
    public init() { }
}
