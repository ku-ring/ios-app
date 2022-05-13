//
//  ChatViewModel.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringCommons
import SendbirdChatSDK

class ChatViewModel: ObservableObject {
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
    @Published var isScrollable: Bool = true
    @Published var lastMessageIndex: String = "" {
        didSet {
            Logger.debug("viewModel.lastMessageIndex = \(lastMessageIndex)")
        }
    }
    
    // TODO: 글자수 제한 300자
    @Published var text: String = ""
    @Published var isLoading: Bool = false
    
    @Published var currentState: ChatState {
        willSet { currentState.finish(context: self) }
        didSet { currentState.start(context: self) }
    }
    
    var openChannel: OpenChannel
    var query: PreviousMessageListQuery?
    
    enum MessageStatus {
        case sent
        case pending
        case failed
    }
    
    init(channel: OpenChannel) {
        self.openChannel = channel
        self.currentState = ChatConnectingState(channel: channel)
        self.currentState.start(context: self)
        SendbirdChat.add(self as ConnectionDelegate, identifier: StringSet.Campus.connectionDelegateID)
        SendbirdChat.add(self as OpenChannelDelegate, identifier: StringSet.Campus.channelDelegateID)
    }
    
    func changeState(_ newState: ChatState) {
        Logger.debug("\(currentState) -> \(newState) 로 변경합니다.")
        self.currentState = newState
    }
    
    func fetchPreviousMessageList() {
        guard let connectedState = self.currentState as? ChatConnectedState else { return }
        connectedState.fetchPreviousMessageList(context: self)
    }
    
    func sendUserMessage() {
        guard let connectedState = self.currentState as? ChatConnectedState else { return }
        HapticManager.shared.createImpact(style: .soft)
        connectedState.sendUserMessage(context: self)
    }
    
    func resendUserMessage(requestID: String) {
        guard let connectedState = self.currentState as? ChatConnectedState else { return }
        connectedState.resendUserMessage(requestID: requestID, context: self)
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
    
    func didFetchPreviousMessageList(with result: Result<[BaseMessage], Error>) {
        guard let connectingState = self.currentState as? ChatConnectingState else { return }
        connectingState.onCompleteMessageListRetrieval(with: result, context: self)
    }
    
    func isSameDay(currentMessage: BaseMessage, status: MessageStatus) -> Bool {
        var index: Int?
        switch status {
        case .sent:
            index = sentMessages.firstIndex(of: currentMessage)
        case .pending:
            guard let userMessage = currentMessage as? UserMessage else { return false }
            index = pendingMessages.firstIndex(of: userMessage)
        case .failed:
            guard let userMessage = currentMessage as? UserMessage else { return false }
            index = failedMessages.firstIndex(of: userMessage)
        }
        guard let index = index else { return false }
        var prevMessage: BaseMessage?
        switch status {
        case .sent:
            guard index > 0 else { return false }
            prevMessage = sentMessages[index - 1]
        case .pending:
            if index == 0 {
                prevMessage = sentMessages.last
            } else {
                prevMessage = pendingMessages[index - 1]
            }
        case .failed:
            if index == 0 {
                prevMessage = sentMessages.last
            } else {
                prevMessage = failedMessages[index - 1]
            }
        }
        guard let prevMessage = prevMessage else { return false }

        
        let curCreatedAt = currentMessage.createdAt
        let prevCreatedAt = prevMessage.createdAt
        
        return Date.from(prevCreatedAt).isSameDay(as: Date.from(curCreatedAt))
    }
}

extension Date {
    static public func from(_ baseTimestamp: Int64) -> Date {
        let timestampString = String(format: "%lld", baseTimestamp)
        let timeInterval = timestampString.count == 10
            ? TimeInterval(baseTimestamp)
            : TimeInterval(Double(baseTimestamp) / 1000.0)
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    func isSameDay(as otherDate: Date) -> Bool {
        let baseDate = self
        let otherDate = otherDate
 
        let baseDateComponents = Calendar.current.dateComponents(
            [.day, .month, .year],
            from: baseDate
        )
        let otherDateComponents = Calendar.current.dateComponents(
            [.day, .month, .year],
            from: otherDate
        )

        if baseDateComponents.year == otherDateComponents.year,
            baseDateComponents.month == otherDateComponents.month,
            baseDateComponents.day == otherDateComponents.day {
            return true
        }
        else {
            return false
        }
    }
}
