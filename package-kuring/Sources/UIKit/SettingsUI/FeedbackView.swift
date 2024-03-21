//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import ColorSet
import SettingsFeatures
import ComposableArchitecture

public struct FeedbackView: View {
    @Bindable var store: StoreOf<FeedbackFeature>
    @FocusState private var isFocused: Bool

    public var body: some View {
        VStack(spacing: 0) {
            if !store.isTopHidden {
                Image("feedback", bundle: Bundle.settings)
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipped()
                    .padding(.top, 56)

                Text("피드백을 보내주시면\n앱 성장에 많은 도움이 돼요.😇")
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }

            VStack {
                TextEditor(text: $store.text)
                    .foregroundStyle(
                        store.text == store.placeholder
                            ? Color.caption1.opacity(0.6)
                            : .primary
                    )
                    .focused($isFocused)
                    .padding(20)
                    .frame(height: 200)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                store.text == store.placeholder
                                    ? Color.caption1.opacity(0.6)
                                    : Color.accentColor,
                                lineWidth: 1
                            )
                            .foregroundColor(.clear)
                    )

                HStack {
                    Spacer()

                    Text(store.guideline)
                        .foregroundStyle(
                            store.isSendable
                                ? Color.accentColor
                                : Color.red // TODO: error color 적용
                        )
                        .padding(.trailing, 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            .padding(.top, store.isTopHidden ? 32 : 27)

            if !store.isTopHidden {
                Spacer()
            }

            Button {
                guard store.isSendable else { return }
                store.send(.sendFeedback)
            } label: {
                topBlurButton(
                    "피드백 보내기",
                    fontColor: store.isSendable
                        ? .white
                        : ColorSet.primary.opacity(0.4),
                    backgroundColor: store.isSendable
                        ? ColorSet.primary
                        : ColorSet.primary.opacity(0.15)
                )
            }
            .allowsHitTesting(store.isSendable)
            .padding(.horizontal, 20)
            .padding(.bottom)
            .padding(.top, 24)

            if store.isTopHidden {
                Spacer()
            }
        }
        .bind($store.isFocused, to: $isFocused)
        .onChange(of: isFocused) { _, newValue in
            withAnimation {
                store.isTopHidden = newValue
            }
        }
    }

    public init(store: StoreOf<FeedbackFeature>) {
        self.store = store
    }

    // TODO: 디자인 시스템 분리 - 상단에 블러가 존재하는 버튼
    @ViewBuilder
    private func topBlurButton(_ title: String, fontColor: Color, backgroundColor: Color) -> some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()

            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(fontColor)

            Spacer()
        }
        .padding(.horizontal, 50)
        .padding(.vertical, 16)
        .frame(height: 50, alignment: .center)
        .background(backgroundColor)
        .cornerRadius(100)
    }
}

#Preview {
    NavigationStack {
        FeedbackView(
            store: Store(
                initialState: FeedbackFeature.State(),
                reducer: { FeedbackFeature() }
            )
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("피드백 보내기")
    }
}
