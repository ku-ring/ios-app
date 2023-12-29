import Models
import SwiftUI
import ComposableArchitecture

@Reducer
public struct SubscriptionAppFeature {
    @ObservableState
    public struct State: Equatable {
        /// 스택 기반 네비게이션 Path
        public var path = StackState<Path.State>()
        /// Root
        public var subscriptionView = SubscriptionFeature.State()
        
        public init(
            path: StackState<SubscriptionAppFeature.Path.State> = .init(),
            root: SubscriptionFeature.State = .init()
        ) {
            self.path = path
            self.subscriptionView = root
        }
    }
    
    public enum Action: Equatable {
        /// 스택 기반 네비게이션 Path
        case path(StackAction<Path.State, Path.Action>)
        /// Root
        case subscriptionView(SubscriptionFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.subscriptionView, action: \.subscriptionView) {
            SubscriptionFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .path(.popFrom(id: id)):
                guard case let .some(.departmentEditor(departmentEditorState)) = state.path[id: id] else {
                    return .none
                }
                state.subscriptionView.myDepartments = departmentEditorState.myDepartments
                return .none
                
            case .path:
                return .none
                
            case .subscriptionView:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
    
    public init() {
        
    }
}
