import SubscriptionFeatures
import ComposableArchitecture

@Reducer
public struct SettingsAppFeature {
    @ObservableState
    public struct State: Equatable {
        /// 트리 기반 네비게이션 Path
        @Presents public var destination: Destination.State?
        /// 스택 기반 네비게이션 Path
        public var path = StackState<Path.State>()
        /// Root
        public var settingList = SettingListFeature.State()
        
        public init(
            destination: Destination.State? = nil,
            path: StackState<Path.State> = .init(),
            root: SettingListFeature.State = .init()
        ) {
            // 디펜던시로 세팅
            self.destination = destination
            self.path = path
        }
    }
    
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        /// Root
        case settingList(SettingListFeature.Action)
        /// 스택 기반 네비게이션 Path
        case path(StackAction<Path.State, Path.Action>)
        /// 트리기반 네비게이션 Destination
        case destination(PresentationAction<Destination.Action>)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.settingList, action: \.settingList) {
            SettingListFeature()
        }
    
        Reduce { state, action in
            switch action {
            case let .settingList(.delegate(action)):
                switch action {
                case .showSubscription:
                    state.destination = .subscription(SubscriptionAppFeature.State())
                    return .none
                    
                case .showWhatsNew:
                    state.destination = .informationWeb(
                        InformationWebFeature.State(url: URLLink.whatsNew.rawValue)
                    )
                    return .none
                    
                case .showTeam:
                    state.destination = .informationWeb(
                        InformationWebFeature.State(url: URLLink.team.rawValue)
                    )
                    return .none
                    
                case .showPrivacyPolicy:
                    state.destination = .informationWeb(
                        InformationWebFeature.State(url: URLLink.privacy.rawValue)
                    )
                    return .none
                    
                case .showTermsOfService:
                    state.destination = .informationWeb(
                        InformationWebFeature.State(url: URLLink.terms.rawValue)
                    )
                    return .none
                    
                case .showInstagram:
                    state.destination = .informationWeb(
                        InformationWebFeature.State(url: URLLink.instagram.rawValue)
                    )
                    return .none
                    
                case .showFeedback:
                    state.destination = .feedback(FeedbackFeature.State())
                    return .none
                }
                
            case let .path(.element(id: id, action: .appIconSelector(.delegate(.completeAppIconChange)))):
                guard case let .appIconSelector(appIconSelectorState) = state.path[id: id] else {
                    return .none
                }
                state.settingList.currentAppIcon = appIconSelectorState.selectedIcon
                state.path.pop(from: id)
                return .none
            
            case .binding:
                return .none
            
            case .destination, .path:
                return .none
                
            case .settingList:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
    
    public init() { }
}
