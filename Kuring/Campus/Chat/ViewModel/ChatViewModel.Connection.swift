//
//  ChatViewModel.Connection.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import Foundation
import KuringCommons
import SendbirdChatSDK

extension ChatViewModel: ConnectionDelegate {
    func didConnect(userID: String) {
        Logger.error(#function)
        
        currentState.onConnected(context: self)
    }
    
    func didSucceedReconnection() {
        Logger.debug(#function)
        sentMessages = []
        
        currentState.onConnected(context: self)
        guard let connectedState = self.currentState as? ChatConnectedState else {
            return
        }
        connectedState.fetchPreviousMessageList(context: self)
    }
    
    func didFailReconnection() {
        Logger.error(#function)
        
        currentState.onDisconnected(context: self)
    }
    
    func didDisconnect(userID: String) {
        Logger.error(#function)
        
        currentState.onDisconnected(context: self)
    }
    
    func didStartReconnection() {
        Logger.error(#function)
        
        currentState.onConnecting(context: self)
    }
}
