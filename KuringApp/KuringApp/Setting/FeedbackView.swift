//
//  FeedbackView.swift
//  KuringApp
//
//  Created by 박성수 on 11/29/23.
//

import SwiftUI
import ComposableArchitecture

struct FeedbackFeature: Reducer {
    
    struct State: Equatable {
        var text: String = "피드백을 남겨주세요."
        
    }
    
    enum Action: Equatable {
        case eraseView
        
        case delegate(Delegate)
        enum Delegate: Equatable {
            case erase
        }
        
        case typing(String)
        case sendFeedback
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .eraseView:
                return .run { send in
                    await send(.delegate(.erase))
                }
                
            case .delegate:
                return .none
            case let .typing(value):
                state.text = value
                return .none
            case .sendFeedback:
                return .none
            }
        }
    }
}

struct FeedbackView: View {
    let store: StoreOf<FeedbackFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 30) {
                Text("피드백 보내기")
                    .fontWeight(.bold)
                    .padding(.top)
                Image(systemName: "pencil")
                    .resizable()
                    .frame(width: 120, height: 120)
                Text("피드백을 보내주시면\n앱 성장에 많은 도움이 됩니다.😇")
                    .multilineTextAlignment(.center)
                
                VStack {
                    TextEditor(text: viewStore.binding(
                        get: \.text,
                        send: { .typing($0) })
                    )
                    .padding()
                    .frame(height: 200)
                    .cornerRadius(8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.green, lineWidth: 1)
                            .foregroundColor(.clear)
                            .frame(maxHeight: 180)
                    )
                    .padding(.horizontal)
                    
                    
                    HStack {
                        Spacer()
                        Text("4글자 이상 입력해주세요.")
                            .padding(.horizontal)
                    }
                }
                
                Spacer()
                Button(action: {
                    viewStore.send(.sendFeedback)
                }) {
                    Text("피드백 보내기")
                }
                .disabled(viewStore.text.count < 4)
                .padding(.bottom)
            }
            .onDisappear {
                viewStore.send(.eraseView)
            }
        }
    }
}

#Preview {
    FeedbackView(
        store: Store(
            initialState: FeedbackFeature.State(),
            reducer: { FeedbackFeature() }
        )
    )
}

