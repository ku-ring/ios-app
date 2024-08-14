//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftData
import Foundation

@Model
public class ChatInfo {
    @Attribute(.unique) 
    public var index: Int
    public var text: String
    public var type: MessageType
    public var chatStatus: ChatStatus
    
    public enum MessageType: String, Equatable, Codable {
        case question
        case answer
    }
    
    public enum ChatStatus: Codable {
        case before
        case waiting
        case complete
        case failure
    }
    
    public init(
        index: Int = 1,
        text: String = "",
        type: MessageType = .question,
        chatStatus: ChatStatus = .before
    ) {
        self.index = index
        self.text = text
        self.type = type
        self.chatStatus = chatStatus
    }
}
