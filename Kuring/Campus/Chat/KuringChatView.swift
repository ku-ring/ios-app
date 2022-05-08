//
//  KuringChatView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringCommons
import SendbirdChatSDK

// 앱실행
// Sendbird init with appID

// 온보딩
// userID: fcm token
// connect(userID:)


// 닉네임 입력창 띄우고
// 닉네임 입력 후 확인누르면
// open channel
// nicknames
// comparison
// 에러 -> 중복된 닉네임입니다.

// 채팅뷰
// SendbirdChat.currentUser == nil
// Sendbird init
// connect(userID)
// openChannel.enter

struct KuringChatView: View {
    @ObservedObject var viewModel: KuringChatViewModel
    
    var body: some View {
        ZStack {
            MessageList(viewModel: viewModel)
            
            if viewModel.isLoading {
                LottieView(filename: "lottieLoading")                
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
        self.viewModel = KuringChatViewModel(channel: channel)
    }
}
