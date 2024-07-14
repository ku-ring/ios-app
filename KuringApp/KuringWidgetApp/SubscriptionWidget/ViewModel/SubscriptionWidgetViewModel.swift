//
//  SubscriptionWidgetViewModel.swift
//  KuringWidgetExtension
//
//  Created by Geon Woo lee on 2/9/24.
//

import WidgetKit

struct SubscriptionWidgetViewModel: TimelineEntry {
    
    var date: Date = .now
    /// 일반 공지 타입
    var noticeTypes: [String] = ["학사", "취창업", "국제", "장학", "도서관", "학생", "산학", "일반"]
    
    init() {}
    
    static func defaultEntry() -> SubscriptionWidgetViewModel {
        return .init()
    }
}
