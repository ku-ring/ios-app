//
//  ChatStartedState.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/08.
//

import Foundation
import SendbirdChatSDK

class ChatStartedState: CampusState {
    let channel: OpenChannel
    
    init(channel: OpenChannel) {
        self.channel = channel
    }
}
