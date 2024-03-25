//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import Foundation
import Dependencies

public struct KuringSubscriptions {
    /// 구독한 공지 리스트 업데이트
    public var update: (_ noticeProvider: Set<NoticeProvider>) -> Void
    /// 구독한 모든 공지 카테고리
    public var getAll: () -> Set<NoticeProvider>
    /// 커스텀 공지 구독 여부
    public var isCustomNotification: () -> Bool
    /// 커스텀 공지 구독 여부 변경
    public var changeCustomNotification: (_ isSubscribe: Bool) -> Void
    
    /// 구독한 공지 (대학 및 학괴)
    @UserDefault(key: StringSet.subscribedCategories, defaultValue: [])
    static var subscriptions: Set<NoticeProvider>
    
    /// 커스텀 공지 구독 여부 (기본값 true)
    @UserDefault(key: StringSet.customNotification, defaultValue: true)
    static var isCustomNotification: Bool
}

extension KuringSubscriptions {
    public static let `default` = Self(
        update: { noticeProviders in
            Self.subscriptions = noticeProviders
            
        }, getAll: {
            Self.subscriptions
            
        }, isCustomNotification: {
            Self.isCustomNotification
            
        }, changeCustomNotification: { isSubscribe in
            Self.isCustomNotification = isSubscribe
            
        }
    )

}

extension KuringSubscriptions: DependencyKey {
    public static var liveValue: KuringSubscriptions = .default
}

extension DependencyValues {
    public var subscriptions: KuringSubscriptions {
        get { self[KuringSubscriptions.self] }
        set { self[KuringSubscriptions.self] = newValue }
    }
}
