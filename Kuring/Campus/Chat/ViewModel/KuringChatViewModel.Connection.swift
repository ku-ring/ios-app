//
//  KuringChatViewModel.Connection.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import Foundation
import KuringCommons
import SendbirdChatSDK

extension KuringChatViewModel: ConnectionDelegate {
    func didSucceedReconnection() {
        Logger.debug(#function)
        self.sentMessages = []
        connect()
    }
    
    func didFailReconnection() {
        Logger.error(#function)
    }
}
