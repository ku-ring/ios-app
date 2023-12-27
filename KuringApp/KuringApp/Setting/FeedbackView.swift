//
//  FeedbackView.swift
//  KuringApp
//
//  Created by 박성수 on 11/29/23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct FeedbackFeature {
    @ObservableState
    struct State: Equatable {
        var text: String = "피드백을 남겨주세요."
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        
        case sendFeedback
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
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
}

struct FeedbackView: View {
    @Bindable var store: StoreOf<FeedbackFeature>
    
    var body: some View {
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
                TextEditor(text: $store.text)
                    .padding()
                    .frame(height: 200)
                    .cornerRadius(8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.accentColor, lineWidth: 1)
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
            
            Button {
                store.send(.sendFeedback)
            } label: {
                Text("피드백 보내기")
            }
            .disabled(store.text.count < 4)
            .padding(.bottom)
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

