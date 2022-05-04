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
                    VStack(spacing: 8) {
                        ForEach(viewModel.sentMessages, id: \.requestID) { message in
                            if let userMessage = message as? UserMessage {
                                MessageBubble(viewModel: viewModel, userMessage: userMessage)
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
