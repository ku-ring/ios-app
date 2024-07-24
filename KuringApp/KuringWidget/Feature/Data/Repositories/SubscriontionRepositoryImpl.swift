//
//  SubscriontionRepositoryImpl.swift
//  KuringApp
//
//  Created by Geon Woo lee on 7/25/24.
//

import Caches
import Models
import Dependencies

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
