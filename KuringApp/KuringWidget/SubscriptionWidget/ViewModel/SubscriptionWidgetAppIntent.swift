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

/// 공지 구독
struct SubscriontionRepository {
    @Dependency(\.kuringLink) var kuringLink
    
    /// 대학 구독 정보 갱신
    ///
    /// - Note: Swift 6.0이후 throw에 Error 타입 지정할 수 있음.
    /// - Note: `Result`로 처리하면 더 명확하나, 기존 설계가 `Bool`로 응답 결과를 결정하고 있어서 해당 흐름을 따라가도록 설계
    func updateUnivSubscription(selections: Set<NoticeProvider>) async -> Bool {
        let typeNames = DataStorageManager.shared.subscriptions.compactMap { $0.name }
        
        let result = try? await kuringLink.subscribeUnivNotices(typeNames)
        return result ?? false
    }
}

struct WidgetSubscriponProvider {
    @Dependency(\.kuringLink) var kuringLink
    @Dependency(\.subscriptions) var subscriptions
    
    private let subscriontionRepository = SubscriontionRepository()
    
    /// 위젯 구독 선택에 따른 상태 변경
    func selection(noticeProvider: NoticeProvider) async {
        var snapshot = DataStorageManager.shared.subscriptions
        
        if snapshot.contains(where: { $0 == noticeProvider }) {
            // 기존에 구독했던 경우 > 삭제
            snapshot.remove(noticeProvider)
        } else {
            // 구독하지 않았던 경우 > 등록
            snapshot.insert(noticeProvider)
        }
        
        // 서버 데이터 통신
        let result = await subscriontionRepository.updateUnivSubscription(
            selections: snapshot
        )
        
        // 로컬 데이터 갱신
        switch result {
        case true:
            subscriptions.update(snapshot)
        case false:
            break
        }
    }
    
}
