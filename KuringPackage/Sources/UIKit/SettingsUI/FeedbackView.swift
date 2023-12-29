import SwiftUI
import SettingsFeatures
import ComposableArchitecture

public struct FeedbackView: View {
    @Bindable var store: StoreOf<FeedbackFeature>
    
    public var body: some View {
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
    
    public init(store: StoreOf<FeedbackFeature>) {
        self.store = store
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

