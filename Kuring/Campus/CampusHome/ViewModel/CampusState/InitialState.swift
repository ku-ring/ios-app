//
//  InitialState.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/08.
//

import Foundation
import KuringSDK
import SendbirdChatSDK

class InitialState: CampusState {
    func start(context: CampusViewModel) {
        let params = InitParams(applicationID: KuringCampus.appID)
        SendbirdChat.initialize(params: params)
        context.changeState(to: ConnectingState())
    }
}
