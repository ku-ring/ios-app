//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import ComposableArchitecture
import ColorSet
import Networks
import SwiftData
import BotFeatures

public struct BotView: View {
    @Bindable var store: StoreOf<BotFeature>
    @FocusState private var isInputFocused: Bool
    @State private var isPopoverVisible = false
    @State private var isSendPopupVisible = false
    @State private var tempInputText: String = ""
    @State private var isLoading = false
    
    public var body: some View {
        ZStack {
            Color.Kuring.bg
                .ignoresSafeArea()
                .onTapGesture {
                    isInputFocused = false
                }
            
            VStack(alignment: .center) {
                headerView
                chatView
                inputView
                infoText
            }
            .padding(.bottom, 16)
            
            if isSendPopupVisible {
                sendPopup
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    private var headerView: some View {
        HStack {
            backButton
            Spacer()
            titleText
            Spacer()
            infoButton
        }
        .padding(.horizontal, 18)
    }
    
    private var backButton: some View {
        Button {
            // 뒤로 가기 버튼 동작 구현
        } label: {
            Image(systemName: "chevron.backward")
                .padding()
                .frame(width: 20, height: 11)
                .foregroundStyle(Color.black)
        }
    }
    
    private var titleText: some View {
        Text("쿠링봇")
            .padding()
            .font(.system(size: 18, weight: .semibold))
    }
    
    private var infoButton: some View {
        Button {
            isPopoverVisible.toggle()
        } label: {
            Image("icon_info_circle", bundle: Bundle.bots)
        }
        .popover(isPresented: $isPopoverVisible, arrowEdge: .top) {
            popoverContent
        }
    }
    
    private var popoverContent: some View {
        VStack(spacing: 10) {
            Text("• 쿠링봇은 2024년 6월 이후의 공지\n  사항 내용을 기준으로 답변할 수 있\n  어요.")
            Text("• 테스트 기간인 관계로 한 달에 2회\n  까지만 질문 가능해요.")
        }
        .lineSpacing(5)
        .font(.system(size: 15, weight: .medium))
        .padding(20)
        .presentationBackground(Color.Kuring.gray100)
        .presentationCompactAdaptation(.popover)
    }
    
    @ViewBuilder
    private var chatView: some View {
        if !store.state.chatHistory.isEmpty {
            ChatView(store: self.store)
        } else {
            ChatEmptyView()
        }
    }
    
    private var inputView: some View {
        HStack(alignment: .bottom, spacing: 12) {
            TextField("질문을 입력해주세요", text: $tempInputText.limit(to: 300), axis: .vertical)
                .lineLimit(5)
                .focused($isInputFocused)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.Kuring.gray200, style: StrokeStyle(lineWidth: 1.0)))
            
            sendButton
        }
        .padding(.horizontal, 20)
//        .disabled(store.chatHistory.count >= 4)
    }
    
    private var sendButton: some View {
        Button {
            isInputFocused = false
            isSendPopupVisible = true
        } label: {
            Image(systemName: "arrow.up.circle.fill")
                .resizable()
                .foregroundStyle(Color.Kuring.gray400)
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
//        .disabled(store.chatHistory.count >= 4)
    }
    
    private var infoText: some View {
        Text("쿠링봇은 실수를 할 수 있습니다. 중요한 정보를 확인하세요.")
            .foregroundStyle(Color.Kuring.caption2)
            .font(.system(size: 12, weight: .medium))
            .padding(.top, 8)
    }
    
    private var sendPopup: some View {
        SendPopup(isVisible: $isSendPopupVisible) {
            isLoading = true
            store.send(.addQuestion(tempInputText))
            tempInputText = ""
            store.send(.sendMessage)
            isLoading = false
        }
    }
    
    public init(store: StoreOf<BotFeature>) {
        self.store = store
    }
}

/// 글자 수 max 판단
extension Binding where Value == String {
    func limit(to maxLength: Int) -> Self {
        if self.wrappedValue.count > maxLength {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(maxLength))
            }
        }
        return self
    }
}
