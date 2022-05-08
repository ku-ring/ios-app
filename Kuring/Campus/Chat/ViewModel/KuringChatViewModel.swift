//
//  KuringChatViewModel.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringCommons
import SendbirdChatSDK

class KuringChatViewModel: ObservableObject {
    @Published private(set) var onDismiss: Bool = false
    
    @Published var sentMessages: [BaseMessage] = [] {
        didSet {
            Logger.debug("viewModel.sentMessages 에 \(String(describing: sentMessages.last))를 추가하였습니다.")
        }
    }
    @Published var pendingMessages: [UserMessage] = [] {
        didSet {
            Logger.debug("viewModel.pendingMessages 에 \(String(describing: pendingMessages.last))를 추가하였습니다.")
        }
    }
    @Published var failedMessages: [UserMessage] = [] {
        didSet {
            Logger.debug("viewModel.failedMessages 에 \(String(describing: failedMessages.last))를 추가하였습니다.")
        }
    }
    @Published var lastMessageIndex: String = "" {
        didSet {
            Logger.debug("viewModel.lastMessageIndex = \(lastMessageIndex)")
        }
    }
    
    // TODO: 글자수 제한 300자
    @Published var text: String = ""
    @Published var isLoading: Bool = false
    
    var openChannel: OpenChannel
    var query: PreviousMessageListQuery?
    
    init(channel: OpenChannel) {
        self.openChannel = channel
        SendbirdChat.add(self as ConnectionDelegate, identifier: StringSet.Campus.connectionDelegateID)
        SendbirdChat.add(self as OpenChannelDelegate, identifier: StringSet.Campus.channelDelegateID)
        self.fetchPreviousMessageList()
    }
    
    func sendUserMessage() {
        Logger.debug(#function)
        let pendingMessage = openChannel.sendUserMessage(text) { message, error in
            self.updateLastMessageIndex()
            defer { Logger.error(error) }
            guard let message = message else { return }
            switch message.sendingStatus {
            case .failed:
                Logger.error("메세지 \(message.requestID)를 전송 싪패했습니다.")
                self.pendingMessages.removeAll { $0.requestID == message.requestID }
                self.failedMessages.append(message)
            case .succeeded:
                Logger.debug("메세지 \(message.requestID)를 전송하였습니다.")
                self.pendingMessages.removeAll { $0.requestID == message.requestID }
                self.sentMessages.append(message)
            case .pending:
                Logger.debug("메세지 \(message.requestID)를 전송하고 있습니다.")
            default: return
            }
        }
        text = ""
        pendingMessages.append(pendingMessage)
        updateLastMessageIndex()
    }
    
    func resendUserMessage(requestID: String) {
         guard let failedMessage = self.failedMessages.first(where: { $0.requestID == requestID }) else { return }
        Logger.debug(#function)
        failedMessages.removeAll { $0.requestID == requestID }
        let pendingMessage = openChannel.resendUserMessage(failedMessage) { [requestID] message, error in
            defer { Logger.error(error) }
            self.pendingMessages.removeAll { $0.requestID == requestID }
            guard let message = message else { return }
            switch message.sendingStatus {
            case .failed:
                Logger.error("메세지 \(message.requestID)를 전송 실패했습니다.")
                self.failedMessages.append(message)
            case .succeeded:
                Logger.debug("메세지 \(message.requestID)를 전송하였습니다.")
                self.sentMessages.append(message)
            default: return
            }
        }
        pendingMessages.append(pendingMessage)
    }
    
    func deleteNotSentMessage(requestID: String) {
        Logger.debug(#function)
        failedMessages.removeAll { $0.requestID == requestID }
        pendingMessages.removeAll { $0.requestID == requestID }
        updateLastMessageIndex()
    }
    
    func updateLastMessageIndex() {
        lastMessageIndex = self.pendingMessages.last?.requestID
        ?? self.failedMessages.last?.requestID
        ?? ""
        if lastMessageIndex.isEmpty, let lastSentMessage = self.sentMessages.last {
            lastMessageIndex = "\(lastSentMessage.messageID)"
        }
    }
    
    func fetchPreviousMessageList() {
        Logger.debug(#function)
        self.isLoading = true
        
        let params = MessageListParams()
        params.previousResultSize = 100
        let timestamp = self.sentMessages.first?.createdAt ?? Int64.max
        openChannel.getMessagesByTimestamp(timestamp, params: params) { messages, error in
            self.isLoading = false
            
            let fetchedMessages = messages ?? []
            Logger.debug("\(fetchedMessages.count) 개의 메세지를 가져왔습니다.")
            if fetchedMessages.isEmpty { return }
            for message in fetchedMessages {
                switch message {
                case let userMessage as UserMessage:
                    if userMessage.messageID == self.sentMessages.last?.messageID { return }
                    self.sentMessages.append(message)
                case let adminMessage as AdminMessage:
                    if adminMessage.messageID == self.sentMessages.last?.messageID { return }
                    self.sentMessages.append(message)
                default: return
                }
            }
            self.updateLastMessageIndex()
        }
    }
    
    func fetchRecentMessageList() {
        Logger.debug(#function)
        let params = MessageListParams()
        params.nextResultSize = 20
        let timestamp = self.sentMessages.first?.createdAt ?? Int64.max
        openChannel.getMessagesByTimestamp(timestamp, params: params) { messages, error in
            let fetchedMessages = messages ?? []
            if fetchedMessages.isEmpty { return }
            for message in fetchedMessages {
                if message.messageID == self.sentMessages.last?.messageID { return }
                self.sentMessages.append(message)
            }
            self.fetchPreviousMessageList()
        }
    }
}

