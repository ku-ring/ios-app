import Models
import Foundation
import ComposableArchitecture

@Reducer
public struct FeedbackFeature {
    @ObservableState
    public struct State: Equatable {
        public let minLimit: Int = 4
        public let maxLimit: Int = 256
        /// TextEditor 의 placeholder
        public let placeholder: String = "피드백을 남겨주세요."
        
        /// 피드백 텍스트
        public var text: String = ""
        
        /// TextEditor 활성화 여부
        public var isFocused: Bool = true
        
        /// TextEditor 하단에 보여질 안내문구
        public var guideline: String {
            isSendable
            ? "글자수: \(self.text.count)/\(maxLimit)"
            : "\(minLimit)글자 이상 입력 해주세요"
        }
        
        /// `text` 가 `placeholder` 가 아니고, 글자수가 `minLimit` 이상일 때
        public var isSendable: Bool {
            self.text != placeholder 
            && self.text.count >= minLimit
        }
        
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
            case .binding(\.isFocused):
                if state.isFocused, state.text == state.placeholder {
                    /// `focus` 활성화 될 때, `text`가 placeholder 상태면 **Empty String** 으로 세팅
                    state.text = ""
                } else if !state.isFocused, state.text.isEmpty {
                    /// `focus` 비활성화 될 때, `text`가 비어있으면, **placeholder** 로 세팅
                    state.text = state.placeholder
                }
                return .none
                
            case .binding:
                return .none
                
            case .sendFeedback:
                state.isFocused = false
                state.text = state.placeholder
                return .run { _ in
                    await dismiss()
                }
            }
        }
    }
    
    public init() { }
}

