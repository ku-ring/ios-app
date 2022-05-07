//
//  ChannelRetrievalState.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/08.
//

import Foundation
import KuringCommons
import SendbirdChatSDK

class ChannelRetrievalState: CampusState {
    let channel: OpenChannel
    
    init(channel: OpenChannel) {
        self.channel = channel
    }
    
    func start(context: CampusViewModel) {
        channel.enter { [weak channel, context] error in
            guard let channel = channel else {
                Logger.error("채널에 대한 메모리 참조를 잃었습니다.")
                return
            }
            if let error = error {
                Logger.error(error)
                return
            }
            context.changeState(to: ChatStartedState(channel: channel))
        }
    }
}
