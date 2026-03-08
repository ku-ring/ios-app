//
//  NotificationHistory.swift
//  Models
//
//  Created by Jung Hwan Park on 3/5/26.
//

import SwiftData
import Foundation

@Model
public final class NotificationHistoryEntity {
    @Attribute(.unique) public var id: String
    public var title: String
    public var body: String
    public var receivedAt: Date
    public var type: String
    public var isRead: Bool
    
    public init(
        id: String = UUID().uuidString,
        title: String,
        body: String,
        receivedAt: Date = .now,
        type: String,
        isRead: Bool = false
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.receivedAt = receivedAt
        self.type = type
        self.isRead = isRead
    }
}

extension NotificationHistoryEntity {
    public func timeAgo(from now: Date = .now) -> String {
        let seconds = Int(now.timeIntervalSince(receivedAt))
        
        if seconds < 60 {
            return "\(seconds)초 전"
        }
        
        let minutes = seconds / 60
        if minutes < 60 {
            return "\(minutes)분 전"
        }
        
        let hours = minutes / 60
        if hours < 24 {
            return "\(hours)시간 전"
        }
        
        let days = hours / 24
        return "\(days)일 전"
    }
}
