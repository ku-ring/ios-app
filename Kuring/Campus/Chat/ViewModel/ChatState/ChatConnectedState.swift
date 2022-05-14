//
//  ChatConnectedState.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/09.
//

import Foundation
import KuringCommons
import SendbirdChatSDK

class ChatConnectedState: ChatState {
    let channel: OpenChannel
    
    init(channel: OpenChannel) {
        self.channel = channel
    }
    
    func start(context: ChatViewModel) {
        if context.isLoading == true {
            context.isLoading = false
        }
    }
    
    func fetchPreviousMessageList(context: ChatViewModel) {
        context.isLoading = true
        
        let params = MessageListParams()
        params.previousResultSize = 100
        params.reverse = true
        let timestamp = context.sentMessages.first?.createdAt ?? .max
        channel.getMessagesByTimestamp(timestamp, params: params) { messages, error in
            defer { Logger.error(error) }
            let fetchedMessages = messages ?? []
            Logger.debug("\(fetchedMessages.count) 개의 메세지를 가져왔습니다.")
            if !fetchedMessages.isEmpty {
                for message in fetchedMessages {
                    switch message {
                    case let userMessage as UserMessage:
                        if userMessage.messageID == context.sentMessages.last?.messageID { return }
                        context.sentMessages.insert(message, at: 0)
                    case let adminMessage as AdminMessage:
                        if adminMessage.messageID == context.sentMessages.last?.messageID { return }
                        context.sentMessages.insert(message, at: 0)
                    default: return
                    }
                }                
            }
            context.hasMorePreviousMessages = fetchedMessages.count >= 100
            context.updateLastMessageIndex()
            context.changeState(ChatConnectedState(channel: self.channel))
        }
    }
    
    func sendUserMessage(context: ChatViewModel) {
        Logger.debug(#function)
        let pendingMessage = channel.sendUserMessage(context.text) { [context] message, error in
            defer { Logger.error(error) }
            guard let message = message else { return }
            switch message.sendingStatus {
            case .failed:
                Logger.error("메세지 \(message.requestID)를 전송 싪패했습니다.")
                context.pendingMessages.removeAll { $0.requestID == message.requestID }
                context.failedMessages.append(message)
            case .succeeded:
                Logger.debug("메세지 \(message.requestID)를 전송하였습니다.")
                context.pendingMessages.removeAll { $0.requestID == message.requestID }
                context.sentMessages.append(message)
            case .pending:
                Logger.debug("메세지 \(message.requestID)를 전송하고 있습니다.")
            default: return
            }
        }
        context.text = ""
        context.pendingMessages.append(pendingMessage)
        context.updateLastMessageIndex()
    }
    
    func resendUserMessage(requestID: String, context: ChatViewModel) {
        guard let failedMessage = context.failedMessages.first(where: { $0.requestID == requestID }) else { return }
        Logger.debug(#function)
        context.failedMessages.removeAll { $0.requestID == requestID }
        let pendingMessage = channel.resendUserMessage(failedMessage) { [requestID] message, error in
            defer { Logger.error(error) }
            context.pendingMessages.removeAll { $0.requestID == requestID }
            guard let message = message else { return }
            switch message.sendingStatus {
            case .failed:
                Logger.error("메세지 \(message.requestID)를 전송 실패했습니다.")
                context.failedMessages.append(message)
            case .succeeded:
                Logger.debug("메세지 \(message.requestID)를 전송하였습니다.")
                context.sentMessages.append(message)
            default: return
            }
        }
        context.pendingMessages.append(pendingMessage)
    }
    
    func onDisconnected(context: ChatViewModel) {
        context.changeState(ChatDisconnectedState(channel: channel))
    }
    
    func onConnecting(context: ChatViewModel) {
        context.changeState(ChatConnectingState(channel: channel))
    }
}
