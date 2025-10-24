//
//  AcademicEvent.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/23/25.
//

import Foundation

/// 학사 일정 객체
public struct AcademicEvent: Codable, Equatable, Hashable {
    public let id: Int
    public let eventUid, summary: String
    public let description: String?
    public let category, startTime, endTime: String
}

/// 학사 일정 알림 설정 (서버로 보내는)
public struct AcademicEventPush: Encodable {
    let enabled: Bool
    
    public init(enabled: Bool) {
        self.enabled = enabled
    }
}
