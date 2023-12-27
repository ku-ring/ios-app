import Models
import SwiftUI
import ComposableArchitecture

@Reducer
public struct SubscriptionAppFeature {
    @ObservableState
    public struct State: Equatable {
        public var path = StackState<Path.State>()
        public var subscriptionView = SubscriptionFeature.State()
        
        public init(
            path: StackState<Path.State> = StackState<Path.State>(),
            subscriptionView: SubscriptionFeature.State = SubscriptionFeature.State()
        ) {
            self.path = path
            self.subscriptionView = subscriptionView
        }
    }
    
    public enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case subscriptionView(SubscriptionFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.subscriptionView, action: /Action.subscriptionView) {
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
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
    
    public init() {
        
    }
}
