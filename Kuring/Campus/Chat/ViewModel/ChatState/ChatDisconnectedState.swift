//
//  ChatDisconnectedState.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/09.
//

import Foundation
import SendbirdChatSDK

class ChatDisconnectedState: ChatState {
    let channel: OpenChannel
    
    init(channel: OpenChannel) {
        self.channel = channel
    }
    
    func onConnected(context: ChatViewModel) {
        context.changeState(ChatConnectedState(channel: channel))
    }
    
    func onConnecting(context: ChatViewModel) {
        context.changeState(ChatConnectingState(channel: channel))
    }
}
