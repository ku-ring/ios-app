//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import Networks
import ColorSet
import SwiftData
import BotFeatures
import ComposableArchitecture

public struct BotView: View {
    @Bindable var store: StoreOf<BotFeature>
    @FocusState private var isInputFocused: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var isPopoverVisible = false
    @State private var isSendPopupVisible = false
    @State private var tempInputText: String = ""
    
    public var body: some View {
        ZStack {
            Color.Kuring.bg
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Group {
                    headerView
                    chatView
                }
                .onTapGesture {
                    isInputFocused = false
                }
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
        .navigationBarBackButtonHidden()
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
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .padding()
                .frame(width: 30, height: 20)
                .foregroundStyle(Color.Kuring.gray400)
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
                .renderingMode(.template)
                .foregroundStyle(Color.Kuring.gray200)
        }
        .popover(isPresented: $isPopoverVisible, arrowEdge: .top) {
            popoverContent
        }
    }
    
    private var popoverContent: some View {
        VStack(spacing: 10) {
            Text("• 쿠링봇은 2024년 6월 이후의 공지사항 내용을 기준으로 답변할 수 있어요.")
            Text("• 테스트 기간인 관계로 한 달에 2회까지만 질문 가능해요.")
        }
        .lineSpacing(5)
        .font(.system(size: 15, weight: .medium))
        .frame(width: 250)
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
            TextField("질문을 입력해주세요", text: $tempInputText, axis: .vertical)
                .font(.system(size: 15, weight: .medium))
                .lineLimit(5)
                .focused($isInputFocused)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.Kuring.gray200, style: StrokeStyle(lineWidth: 1.0))
                )
                .onChange(of: tempInputText) { _, newValue in
                    if newValue.count > 300 {
                        tempInputText = String(newValue.prefix(300))
                    }
                }
            sendButton
        }
        .padding(.horizontal, 20)
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
    }
    
    private var infoText: some View {
        Text("쿠링봇은 실수를 할 수 있습니다. 중요한 정보를 확인하세요.")
            .foregroundStyle(Color.Kuring.caption2)
            .font(.system(size: 12, weight: .medium))
            .padding(.top, 8)
    }
    
    private var sendPopup: some View {
        SendPopup(isVisible: $isSendPopupVisible) {
            store.send(.addQuestion(tempInputText))
            tempInputText = ""
        }
    }
    
    public init(store: StoreOf<BotFeature>) {
        self.store = store
    }
}

