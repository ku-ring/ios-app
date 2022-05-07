//
//  ConnectingState.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/08.
//

import Foundation
import KuringSDK
import KuringCommons
import SendbirdChatSDK

class ConnectingState: CampusState {
    func start(context: CampusViewModel) {
        guard let userID = Kuring.userID else {
            context.changeState(to: LoginState())
            return
        }
        
        SendbirdChat.connect(userID: userID) { [context] user, error in
            guard let user = user else {
                Logger.error(error)
                return
            }
            if user.nickname == nil {
                context.changeState(to: UsernameRequestState())
            } else {
                context.changeState(to: ConnectedState())
            }
        }
    }
}
