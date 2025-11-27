//
//  AcademicEvent.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/23/25.
//

import Foundation
import ColorSet

/// 학사 일정 객체
public struct AcademicEvent: Codable, Equatable, Hashable {
    public let id: Int
    public let eventUid, summary: String
    public let description: String?
    public let category, startTime, endTime: String
    
    public init(
        id: Int,
        eventUid: String,
        summary: String,
        description: String?,
        category: String,
        startTime: String,
        endTime: String
    ) {
        self.id = id
        self.eventUid = eventUid
        self.summary = summary
        self.description = description
        self.category = category
        self.startTime = startTime
        self.endTime = endTime
    }
}

/// 학사 일정 알림 설정 (서버로 보내는)
public struct AcademicEventPush: Encodable {
    let enabled: Bool
    
    public init(enabled: Bool) {
        self.enabled = enabled
    }
}

extension AcademicEvent {
    public init(from event: AcademicEventEntity) {
        self.init(
            id: event.id,
            eventUid: event.eventUid,
            summary: event.summary,
            description: event.descriptionText,
            category: event.category,
            startTime: event.startTime,
            endTime: event.endTime
        )
    }
}
