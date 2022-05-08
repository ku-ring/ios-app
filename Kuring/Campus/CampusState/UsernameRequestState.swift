//
//  UsernameRequestState.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/08.
//

import Foundation
import KuringCommons
import SendbirdChatSDK

class UsernameRequestState: CampusState {
    func updateUsername(to username: String, context: CampusViewModel) {
        let params = UserUpdateParams()
        params.nickname = username
        SendbirdChat.updateCurrentUserInfo(
            params: params,
            completionHandler: { [context] error in
                if let error = error {
                    Logger.error(error)
                }
                context.changeState(to: ConnectedState())
            }
        )
    }
}
