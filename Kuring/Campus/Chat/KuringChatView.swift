//
//  KuringChatView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringCommons

// 온보딩
// Sendbird .init with appID
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
        NavigationView {
            VStack {
                MessageList(viewModel: viewModel)
                    .padding(.top, 4)
            }
            .edgesIgnoringSafeArea(.bottom)
            .background { ColorSet.green.color.edgesIgnoringSafeArea(.top) }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(ColorSet.Background.primary.color)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("쿠링청심대")
                        .font(.title3.bold())
                        .foregroundColor(ColorSet.Background.primary.color)
                }
            }
        }
    }
    
    public init() { }
}
