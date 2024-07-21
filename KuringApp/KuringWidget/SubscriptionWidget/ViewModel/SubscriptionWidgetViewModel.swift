//
//  SubscriptionWidgetViewModel.swift
//  KuringWidgetExtension
//
//  Created by Geon Woo lee on 2/9/24.
//

import Models
import Caches
import WidgetKit
import Dependencies

struct SubscriptionWidgetViewModel: TimelineEntry {
    
    var date: Date = .now
    /// 일반 공지 타입
    var noticeTypes: [NoticeProvider] = NoticeProvider.univNoticeTypes
    /// 구독한 학과 리스트
    var subscriptions = Set<NoticeProvider>()
    
    init() {
        @Dependency(\.subscriptions) var subscriptions
        let subscribed = subscriptions.getAll()
        
        self.subscriptions = subscribed
        
//        print("❄️",self.subscriptions, DataStorageManager.shared.subscriptions)
        DataStorageManager.shared.subscriptions
    }
    
    static func defaultEntry() -> SubscriptionWidgetViewModel {
        return .init()
    }
}
