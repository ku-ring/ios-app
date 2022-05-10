//
//  ChatState.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/09.
//

import Foundation
import KuringCommons

protocol ChatState {
    /// 상태가 변하면 바로 호출 됩니다.
    func start(context: ChatViewModel)
    /// 상태가 다른 상태로 옮겨지기 직전 마지막으로 호출됩니다.
    func finish(context: ChatViewModel)
    
    func onConnected(context: ChatViewModel)
    
    func onConnecting(context: ChatViewModel)
    
    func onDisconnected(context: ChatViewModel)
}

extension ChatState {
    func start(context: ChatViewModel) {
        Logger.debug("\(self) \(#function)")
    }
    
    func finish(context: ChatViewModel) {
        Logger.debug("\(self) \(#function)")
    }
    
    func onConnected(context: ChatViewModel) {
        Logger.debug("\(self) \(#function)")
    }
    
    func onConnecting(context: ChatViewModel) {
        Logger.debug("\(self) \(#function)")
    }
    
    func onDisconnected(context: ChatViewModel) {
        Logger.debug("\(self) \(#function)")
    }
}
