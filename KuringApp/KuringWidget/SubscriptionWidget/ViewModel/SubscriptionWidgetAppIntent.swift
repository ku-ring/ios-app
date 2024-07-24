//
//  SubscriptionWidgetAppIntent.swift
//  KuringWidgetExtension
//
//  Created by Geon Woo lee on 2/9/24.
//

import Models
import Caches
import AppIntents
import Dependencies
import ComposableArchitecture
import Networks

struct SubscriptionWidgetAppIntent: AppIntent {
    
    static var title: LocalizedStringResource = "구독 위젯"
    static var description = IntentDescription("쿠링 구독 대화형 위젯")
    
    /// 선택한 구독 카테고리
    @Parameter(title: "selection")
    var selection: String
    
    /// 공지 구독 레포지토리
    /// - note: `Dependecy`가 `Apple`과 `TCA`네이밍이 겹쳐서 외부로 분리
    private let subscriptionProvider = WidgetSubscriponProvider()
    
    init() {}
    
    init(selection: String) {
        self.selection = selection
    }
   
    @MainActor
    func perform() async throws -> some IntentResult {
        var subscriptions = DataStorageManager.shared.subscriptions
        
        /// 선택된 프로바이더
        let selectedProvider = NoticeProvider.allNamesForPicker
            .filter { $0.key == selection }
            .first?
            .value
        
        if let selectedProvider = selectedProvider {
            await subscriptionProvider.selection(noticeProvider: selectedProvider)
        }
        
        return .result()
    }
}
