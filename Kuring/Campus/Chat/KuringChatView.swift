//
//  KuringChatView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringCommons

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

public struct KuringChatView: View {
    @StateObject private var viewModel = KuringChatViewModel()
    
    public var body: some View {
        VStack {
            MessageList(viewModel: viewModel)
                .padding(.top, 4)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    public init() { }
}
