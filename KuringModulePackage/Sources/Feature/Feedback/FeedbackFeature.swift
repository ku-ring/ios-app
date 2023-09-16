//
//  FeedbackFeature.swift
//
//
//  Created by Jaesung Lee on 2023/09/13.
//

import Model
import SwiftUI
import Foundation
import ComposableArchitecture

struct FeedbackFeature: Reducer {
    struct State {
        @BindingState var feedback: Feedback
        var isSendable: Bool = false
        var isExceedTextLimit: Bool = false
        var textEditorColor: Color = Color(uiColor: .tertiaryLabel)
        var textLimitColor: Color = Color.secondary
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case sendButtonTapped
        case sendResponse(Bool)
    }
    
    let textLimit: (min: Int, max: Int) = (min: 5, max: 256)
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .sendButtonTapped:
                guard !state.feedback.content.isEmpty else {
                    return .send(.sendResponse(false))
                }
                guard state.isSendable else {
                    return .send(.sendResponse(false))
                }
                state.isSendable = false
                return .run { send in
                    await send(.sendResponse(true))
                }
                
            case .sendResponse(let _):
                state.feedback = Feedback(content: "")
                // handle result
                return .none
            }
        }
    }
}
