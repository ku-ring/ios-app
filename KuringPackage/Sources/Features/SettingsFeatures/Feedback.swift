import Models
import Foundation
import ComposableArchitecture

@Reducer
public struct FeedbackFeature {
    @ObservableState
    public struct State: Equatable {
        public var text: String = "피드백을 남겨주세요."
        
        public init(text: String = "") {
            self.text = text
        }
    }
    
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case sendFeedback
    }
    
    @Dependency(\.dismiss) public var dismiss
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .sendFeedback:
                return .run { _ in
                    await dismiss()
                }
            }
        }
    }
    
    public init() { }
}

