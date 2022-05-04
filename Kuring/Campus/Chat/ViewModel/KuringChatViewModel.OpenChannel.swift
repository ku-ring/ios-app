//
//  KuringChatViewModel.OpenChannel.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import Foundation
import SendbirdChatSDK

extension KuringChatViewModel: OpenChannelDelegate {
    func channel(_ channel: BaseChannel, didReceive message: BaseMessage) {
        self.sentMessages.append(message)
        self.lastMessageIndex = message.requestID
    }
    
    func channel(_ channel: OpenChannel, userDidEnter user: User) {
        //
    }
    
    func channel(_ channel: OpenChannel, userDidExit user: User) {
        //
    }
    
    func channel(_ channel: BaseChannel, userWasBanned user: User) {
        //
    }
    
    func channel(_ channel: BaseChannel, userWasUnbanned user: User) {
        //
    }
    
    
}

