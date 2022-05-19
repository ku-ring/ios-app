//
//  ChatViewModel.OpenChannel.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import Foundation
import KuringSDK
import SendbirdChatSDK

extension ChatViewModel: OpenChannelDelegate {
    func channel(_ channel: BaseChannel, didReceive message: BaseMessage) {
        guard Kuring.blockedUserIDs.contains(message.sender?.userID ?? "") == false else { return }
        self.sentMessages.append(message)
        self.updateLastMessageIndex()
        notifiesNewMessage = !isAutoScrollable
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

