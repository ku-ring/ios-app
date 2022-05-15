//
//  ChatView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringSDK
import KuringCommons
import SendbirdChatSDK

struct ChatView: View, KeyboardReadable {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: ChatViewModel
    @State private var inputHeight: CGFloat = 44
    
    var isSendable: Bool {
        !viewModel.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ZStack {
                    ZStack(alignment: .bottom) {
                        messageList
                        
                        if viewModel.notifiesNewMessage {
                            Button(action: viewModel.scrollToBottom) {
                                Text("새로운 메세지가 왔습니다.")
                                    .font(.subheadline.bold())
                                    .foregroundColor(ColorSet.Label.green.color)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 20)
                                    .background {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(ColorSet.Background.green.color)
                                    }
                            }
                        }
                    }
                    .safeAreaInset(edge: .bottom) {
                        messageInputField
                            .background {
                                ColorSet.Background.primary.color
                                    .ignoresSafeArea()
                            }
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                }
                .background(ColorSet.Background.primary.color)
                
                if viewModel.isLoading {
                    LottieView(filename: "lottieLoading")
                }
                
                switch viewModel.currentState {
                case is ChatDisconnectedState:
                    Text("연결이 끊겼습니다.")
                        .foregroundColor(ColorSet.pink.color)
                case is ChatConnectingState:
                    LottieView(filename: "lottieLoading")
                default: EmptyView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(ColorSet.primary.color)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("💬 쿠링청심대")
                        .font(.title3.bold())
                        .foregroundColor(ColorSet.Label.primary.color)
                }
            }
        }
    }
    
    init(channel: OpenChannel) {
        self.viewModel = ChatViewModel(channel: channel)
        UITextView.appearance().backgroundColor = .clear
    }
    
    private var messageList: some View {
        ScrollView(showsIndicators: false) {
            ScrollViewReader { reader in
                ZStack {
                    VStack(spacing: 5) {
                        if viewModel.hasMorePreviousMessages {
                            Button(action: viewModel.fetchPreviousMessageList) {
                                Text("이전 메세지 가져오기")
                                    .font(.subheadline.bold())
                            }
                            .foregroundColor(ColorSet.primary.color)
                        }
                        
                        ForEach(viewModel.sentMessages, id: \.messageID) { message in
                            VStack {
                                if !viewModel.isSameDay(currentMessage: message, status: .sent) {
                                    MessageDateView(message: message)
                                }
                                
                                if let userMessage = message as? UserMessage {
                                    UserMessageView(viewModel: viewModel, userMessage: userMessage)
                                } else if let adminMessage = message as? AdminMessage {
                                    AdminMessageView(adminMessage: adminMessage)
                                }
                            }
                        }
                        
                        ForEach(viewModel.failedMessages, id: \.self) { failedMessage in
                            VStack {
                                if !viewModel.isSameDay(currentMessage: failedMessage, status: .failed) {
                                    MessageDateView(message: failedMessage)
                                }
                                
                                UserMessageView(viewModel: viewModel, userMessage: failedMessage)
                            }
                        }
                        
                        ForEach(viewModel.pendingMessages, id: \.self) { pendingMessage in
                            VStack {
                                if !viewModel.isSameDay(currentMessage: pendingMessage, status: .pending) {
                                    MessageDateView(message: pendingMessage)
                                }
                                
                                UserMessageView(viewModel: viewModel, userMessage: pendingMessage)
                            }
                        }
                    }
                    
                    GeometryReader { proxy in
                        let offset = proxy.frame(in: .named("scroll")).minY
                        Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                        
                    }
                }
                .onChange(of: viewModel.lastMessageIndex) { newValue in
                    guard !newValue.isEmpty else { return }
                    guard viewModel.isAutoScrollable else { return }
                    withAnimation {
                        reader.scrollTo(newValue, anchor: .bottom)
                    }
                }
                .onChange(of: viewModel.notifiesNewMessage) { newValue in
                    guard !newValue else { return }
                    withAnimation {
                        reader.scrollTo(viewModel.lastMessageIndex, anchor: .bottom)
                    }
                }
                .onReceive(keyboardPublisher) { _ in
                    withAnimation {
                        reader.scrollTo(viewModel.lastMessageIndex, anchor: .bottom)
                    }
                }
                .padding(.bottom)
                .padding(.top, 25)
            }
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            let isNewBottom = viewModel.bottomOffset + 30 > value
            if isNewBottom {
                viewModel.bottomOffset = value
                viewModel.isAutoScrollable = true
            } else {
                viewModel.isAutoScrollable = false
            }
        }
    }
    
    private var messageInputField: some View {
        HStack(spacing: 0) {
            MessageInput(
                text: $viewModel.text,
                height: $inputHeight
            )
            .frame(height: inputHeight < 90 ? inputHeight : 90)
                .multilineTextAlignment(.leading)
                .opacity(viewModel.text.isEmpty ? 0.5 : 1)
                .padding(.vertical, 2)
                .padding(.horizontal, 12)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(ColorSet.green.color, lineWidth: 1)
                }
                .padding(.vertical, 4)
            
            Button(action: viewModel.sendUserMessage) {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .rotationEffect(.degrees(45))
                    .foregroundColor(ColorSet.green.color)
                    .padding()
            }
            .disabled(!isSendable)
            .opacity(isSendable ? 1.0 : 0.5)
        }
        .padding(.leading, 16)
        .padding(.trailing, 8)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
