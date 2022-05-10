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
    func checkAvailablity(username: String, context: CampusViewModel) {
        KuringCampus.getUser(named: username) { result in
            switch result {
            case .success(let user):
                if user == nil {
                    context.updateUsername()
                } else {
                    context.didFailToSetupUsername(with: "이미 존재하는 닉네임입니다")
                }
                return
            case .failure(let error):
                context.didFailToSetupUsername(with: error.localizedDescription)
                return
            }
        }
        
    }
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
