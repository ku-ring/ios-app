//
//  ConnectedState.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/08.
//

import Foundation
import KuringCommons
import SendbirdChatSDK

class ConnectedState: CampusState {
    func startChat(context: CampusViewModel) {
        OpenChannel.getChannel(url: StringSet.Campus.channelID) { [context] channel, error in
            guard let channel = channel else {
                Logger.error(error)
                context.onError = true
                return
            }
            context.changeState(to: ChannelRetrievalState(channel: channel))
        }
    }
    
    func restart(context: CampusViewModel) {
        self.startChat(context: context)
    }
}
