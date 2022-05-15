//
//  ChatConnectingState.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/09.
//

import Foundation
import KuringCommons
import SendbirdChatSDK

class ChatConnectingState: ChatState {
    let channel: OpenChannel
    let isReconnecting: Bool
    
    init(channel: OpenChannel, isReconnecting: Bool = false) {
        self.channel = channel
        self.isReconnecting = isReconnecting
    }
    
    func start(context: ChatViewModel) {
        if isReconnecting {
            retreiveNewMessageList(context: context)
        } else {
            retriveMessageList(context: context)
        }
    }
    
    func retreiveNewMessageList(context: ChatViewModel) {
        context.isLoading = true
        
        let params = MessageListParams()
        params.nextResultSize = 100
        let timestamp = context.sentMessages.last?.createdAt ?? .max
        channel.getMessagesByTimestamp(timestamp, params: params) { messages, error in
            if let error = error {
                context.didFetchPreviousMessageList(with: .failure(error))
            } else {
                context.didFetchPreviousMessageList(with: .success(messages ?? []))
            }
        }
    }
    
    func retriveMessageList(context: ChatViewModel) {
        context.isLoading = true
        
        let params = MessageListParams()
        params.previousResultSize = 100
        let timestamp = Int64.max
        channel.getMessagesByTimestamp(timestamp, params: params) { messages, error in
            if let error = error {
                context.didFetchPreviousMessageList(with: .failure(error))
            } else {
                context.didFetchPreviousMessageList(with: .success(messages ?? []))
            }
        }
    }
    
    func onCompleteMessageListRetrieval(with result: Result<[BaseMessage], Error>, context: ChatViewModel) {
        switch result {
        case .success(let messages):
            let fetchedMessages = messages
            Logger.debug("\(fetchedMessages.count) 개의 메세지를 가져왔습니다.")
            if !fetchedMessages.isEmpty {
                context.sentMessages = fetchedMessages
            }
            context.hasMorePreviousMessages = fetchedMessages.count >= 100
            context.updateLastMessageIndex()
            context.changeState(ChatConnectedState(channel: channel))
        case .failure(let error):
            Logger.error(error)
            context.changeState(ChatDisconnectedState(channel: channel))
        }
    }
    
    func finish(context: ChatViewModel) {
        context.isLoading = false
    }
    
    func onConnected(context: ChatViewModel) {
        context.changeState(ChatConnectedState(channel: channel))
    }
    
    func onDisconnected(context: ChatViewModel) {
        context.changeState(ChatDisconnectedState(channel: channel))
    }
}
