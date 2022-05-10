//
//  KuringChatView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringCommons
import SendbirdChatSDK

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        ZStack {
            MessageList(viewModel: viewModel)
            
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
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("💬 쿠링청심대")
                    .font(.title3.bold())
                    .foregroundColor(ColorSet.Label.primary.color)
            }
        }
    }
    
    init(channel: OpenChannel) {
        self.viewModel = ChatViewModel(channel: channel)
    }
}
