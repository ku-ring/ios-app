//
//  ConnectedState.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/08.
//

import Foundation
import KuringSDK
import KuringCommons
import SendbirdChatSDK
import FirebaseMessaging

class ConnectedState: CampusState {
    func start(context: CampusViewModel) {
        if let token = SendbirdChat.getPendingPushToken() {
            SendbirdChat.registerDevicePushToken(token, unique: false) { registrationStatus, error in
                SendbirdChat.setPushTriggerOption(Kuring.isCustomNotificationEnabled ? .all : .off)
            }
        } else if let token = Messaging.messaging().apnsToken {
            SendbirdChat.registerDevicePushToken(token, unique: false) { registrationStatus, error in
                SendbirdChat.setPushTriggerOption(Kuring.isCustomNotificationEnabled ? .all : .off)
            }
        }
    }
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
