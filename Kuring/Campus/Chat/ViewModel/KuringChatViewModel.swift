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
    
    var openChannel: OpenChannel?
    var query: PreviousMessageListQuery?
    
    init() {
        SendbirdChat.add(self as ConnectionDelegate, identifier: StringSet.Campus.connectionDelegateID)
        SendbirdChat.add(self as OpenChannelDelegate, identifier: StringSet.Campus.channelDelegateID)
        connect()
    }
    
    func connect() {
        guard SendbirdChat.getCurrentUser() == nil else {
            self.fetchPreviousMessageList()
            return
        }
        self.isLoading = true
        SendbirdChat.connect(userID: KuringCampus.userID) { [weak self] user, error in
            guard let self = self else { return }
            defer { Logger.error(error) }
            
            if let error = error {
                self.isLoading = false
                print(error.localizedDescription)
                return
            }
            
            KuringCampus.getUser(named: "쿠링") { result in
                switch result {
                case .success(let user):
                    Logger.debug(user)
                case .failure(let error):
                    Logger.error(error)
                }
            }
            
            OpenChannel.getChannel(url: "kuring_main_anonymous") { [self] channel, error in
                self.isLoading = false
                defer { Logger.error(error) }
                guard error == nil else { return }
                channel?.enter { error in
                    defer { Logger.error(error) }
                    self.openChannel = channel
                    self.fetchPreviousMessageList()
                }
            }
        }
    }
    
    func sendUserMessage() {
        guard let openChannel = openChannel else { return }
        Logger.debug(#function)
        let pendingMessage = openChannel.sendUserMessage(text) { message, error in
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
        lastMessageIndex = pendingMessage.requestID
    }
    
    func resendUserMessage(requestID: String) {
        guard let openChannel = openChannel else { return }
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
        lastMessageIndex = self.pendingMessages.last?.requestID
        ?? self.failedMessages.last?.requestID
        ?? self.sentMessages.last?.requestID
        ?? ""
    }
    
    func fetchPreviousMessageList() {
        guard let openChannel = openChannel else { return }
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
                if message.requestID == self.sentMessages.last?.requestID { return }
                self.sentMessages.append(message)
            }
            self.lastMessageIndex = fetchedMessages.last?.requestID ?? ""
            if let adminMessage = fetchedMessages.last as? AdminMessage {
                self.lastMessageIndex = "\(adminMessage.messageID)"
            }
        }
    }
    
    func fetchRecentMessageList() {
        guard let openChannel = openChannel else { return }
        Logger.debug(#function)
        let params = MessageListParams()
        params.nextResultSize = 20
        let timestamp = self.sentMessages.first?.createdAt ?? Int64.max
        openChannel.getMessagesByTimestamp(timestamp, params: params) { messages, error in
            let fetchedMessages = messages ?? []
            if fetchedMessages.isEmpty { return }
            for message in fetchedMessages {
                if message.requestID == self.sentMessages.last?.requestID { return }
                self.sentMessages.append(message)
            }
            self.fetchPreviousMessageList()
        }
    }
}

