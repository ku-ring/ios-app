//
//  KuringCampus.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SendbirdChatSDK

struct KuringCampus {
    static var appID: String = "" {
        didSet {
            let params = InitParams(applicationID: KuringCampus.appID)
            SendbirdChat.initialize(params: params)
        }
    }
    static var userID: String = ""
}
