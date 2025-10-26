//
//  AcademicEventEntity.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/25/25.
//

import SwiftData
import Foundation

/// 하나의 학사 일정 객체
@Model
public final class AcademicEventEntity {
    @Attribute(.unique) public var id: Int
    public var eventUid: String
    public var summary: String
    public var descriptionText: String?
    public var category: String
    public var startTime: String
    public var endTime: String
    
    @Relationship(inverse: \AcademicScheduleEntity.events)
    public var schedule: AcademicScheduleEntity?
    
    public init(
        id: Int,
        eventUid: String,
        summary: String,
        descriptionText: String?,
        category: String,
        startTime: String,
        endTime: String
    ) {
        self.id = id
        self.eventUid = eventUid
        self.summary = summary
        self.descriptionText = descriptionText
        self.category = category
        self.startTime = startTime
        self.endTime = endTime
    }
}

/// 모든 학사일정과 마지막으로 갱신된 시간을 담고있는 객체
@Model
public final class AcademicScheduleEntity {
    @Attribute(.unique) public var id: String
    public var lastUpdated: Date
    public var isComplete: Bool = false
    @Relationship(deleteRule: .cascade) public var events: [AcademicEventEntity]
    
    public init(
        id: String = "main",
        lastUpdated: Date = .now,
        events: [AcademicEventEntity]
    ) {
        self.id = id
        self.lastUpdated = lastUpdated
        self.events = events
    }
}

extension AcademicEventEntity {
    convenience public init(from event: AcademicEvent) {
        self.init(
            id: event.id,
            eventUid: event.eventUid,
            summary: event.summary,
            descriptionText: event.description,
            category: event.category,
            startTime: event.startTime,
            endTime: event.endTime
        )
    }
}
