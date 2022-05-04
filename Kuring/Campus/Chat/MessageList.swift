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
    @ObservedObject var viewModel: KuringChatViewModel
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ScrollViewReader { reader in
                    VStack(spacing: 20) {
                        ForEach(viewModel.sentMessages, id: \.requestID) { message in
                            if let userMessage = message as? UserMessage {
                                MessageBubble(viewModel: viewModel, userMessage: userMessage)
                            }
                        }
                        
                        if viewModel.sentMessages.isEmpty {
                            ForEach([0, 1], id: \.self) { _ in
                                MessageBubble(
                                    viewModel: viewModel,
                                    username: "j_sung_0o0",
                                    message: "테스트 메세지 입니다. 사용자와 동일한 닉네임이 있는 경우 이렇게 굵게 표시됩니다. j_sung_0o0. 그럼 계속 메세지를 전송해보세요.",
                                    isSentByMe: false,
                                    sendingState: .failed
                                )
                                
                                MessageBubble(
                                    viewModel: viewModel,
                                    username: "j_sung_0o0",
                                    message: "테스트 메세지 입니다. 사용자와 동일한 닉네임이 있는 경우 이렇게 굵게 표시됩니다. j_sung_0o0. 그럼 계속 메세지를 전송해보세요.",
                                    isSentByMe: true,
                                    sendingState: .sent
                                )
                            }
                        }
                        
                        ForEach(viewModel.failedMessages, id: \.self) { failedMessage in
                            MessageBubble(viewModel: viewModel, userMessage: failedMessage)
                        }
                        
                        ForEach(viewModel.pendingMessages, id: \.self) { pendingMessage in
                            MessageBubble(viewModel: viewModel, userMessage: pendingMessage)
                        }
                    }
                    .onChange(of: viewModel.lastMessageIndex) { newValue in
                        guard !newValue.isEmpty else { return }
                        reader.scrollTo(newValue)
                    }
                    .padding(.bottom)
                    .padding(.top, 25)
                }
            }
            .refreshable { viewModel.fetchPreviousMessageList() }
            
            MessageInputField(viewModel: viewModel)
        }
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        .background(ColorSet.Background.primary.color)
        .clipShape(TopRoundedShape())
    }
}
