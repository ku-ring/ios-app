//
//  MessageList.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringSDK
import KuringCommons
import SendbirdChatSDK

struct MessageList: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ScrollViewReader { reader in
                    VStack(spacing: 5) {
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
                    .onChange(of: viewModel.lastMessageIndex) { newValue in
                        guard !newValue.isEmpty else { return }
                        guard viewModel.isScrollable else { return }
                        withAnimation {
                            reader.scrollTo(newValue, anchor: .bottom)
                        }
                    }
                    .padding(.bottom)
                    .padding(.top, 25)
                }
            }
            .refreshable { viewModel.fetchPreviousMessageList() }
            
            MessageInputField(viewModel: viewModel)
        }
        .padding(
            .bottom,
            UIApplication.shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }?
                .safeAreaInsets.bottom
        )
        .background(ColorSet.Background.primary.color)
    }
}
