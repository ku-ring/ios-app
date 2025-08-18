//
//  NoticeEKEventStore.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 8/16/25.
//

import Models
import EventKit
import CoreLocation
import Dependencies

public struct NoticeEKEventStore {
    public typealias NoticeEKEvent = (store: EKEventStore, event: EKEvent)
    
    /// 전달받은 공지사항으로 EKEvent를 생성
    public var makeEvent: (_ notice: Notice) async -> Void
    /// 생성된 EKEvent 가져오기
    public var getEvent: () -> NoticeEKEvent
    
    static var noticeEKEvent: NoticeEKEvent = (store: .init(), event: .init())
    
    public init(
        makeEvent: @escaping (_: Notice) async -> Void,
        getEvent: @escaping () -> NoticeEKEvent
    ) {
        self.makeEvent = makeEvent
        self.getEvent = getEvent
    }
}

extension NoticeEKEventStore {
    public static let `default` = NoticeEKEventStore(
        makeEvent: { notice in
            return await withCheckedContinuation { continuation in
                let store = EKEventStore()
                let event = EKEvent(eventStore: store)
                let defaults = Self.Default()
                let structuredLocation = EKStructuredLocation(title: defaults.locationTitle)
                structuredLocation.geoLocation = defaults.geoLocation
                
                event.title = notice.subject
                event.url = URL(string: notice.url)
                event.isAllDay = true
                event.notes = defaults.notes
                event.alarms = [defaults.alarm]
                event.structuredLocation = structuredLocation
                
                Self.noticeEKEvent = (store: store, event: event)
                continuation.resume()
            }
        }, getEvent: {
            return Self.noticeEKEvent
        })
}

extension NoticeEKEventStore: DependencyKey {
    public static var liveValue: NoticeEKEventStore = .default
}

extension DependencyValues {
    public var noticeEKEventStore: NoticeEKEventStore {
        get { self[NoticeEKEventStore.self] }
        set { self[NoticeEKEventStore.self] = newValue }
    }
}

extension NoticeEKEventStore {
    /// 이벤트를 만들때 사용되는 정적 변수
    struct Default {
        /// 위치 이름
        let locationTitle = "건국대학교 05029 대한민국 서울특별시 광진구 능동로 120"
        /// 위치 좌표
        let geoLocation = CLLocation(latitude: 37.54360, longitude: 127.07747)
        /// 24시간 전 알림
        let alarm = EKAlarm(relativeOffset: -86400)
        /// 이벤트 상세 내용
        let notes = "쿠링에서 \(Date.now)에 등록된 일정입니다."
    }
}
