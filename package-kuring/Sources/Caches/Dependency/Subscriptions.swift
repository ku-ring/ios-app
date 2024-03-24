//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import Foundation
import Dependencies

public struct KuringSubscriptions {
    /// 구독한 공지 추가
    public var add: (_ noticeProvider: NoticeProvider) -> Void
    /// 구독한 공지 제거
    public var remove: (_ noticeProvider: NoticeProvider) -> Void
    /// 구독한 모든 공지 카테고리
    public var getAll: () -> [NoticeProvider]
    /// 커스텀 공지 구독 여부
    public var isCustomNotification: () -> Bool
    /// 커스텀 공지 구독 여부 변경
    public var changeCustomNotification: (_ isSubscribe: Bool) -> Void
    
    /// 구독한 공지 (대학 및 학괴)
    @UserDefault(key: StringSet.subscribedCategories, defaultValue: [])
    static var subscriptions: [NoticeProvider]
    
    /// 커스텀 공지 구독 여부 (기본값 true)
    @UserDefault(key: StringSet.customNotification, defaultValue: true)
    static var isCustomNotification: Bool
}

extension KuringSubscriptions {
    public static let `default` = Self(
        add: { noticeProvider in
            var subscriptions = Self.subscriptions
            subscriptions.append(noticeProvider)
            Self.subscriptions = subscriptions
            
        }, remove: { noticeProvider in
            var subscriptions = Self.subscriptions
            subscriptions.removeAll { $0.id == noticeProvider.id }
            Self.subscriptions = subscriptions
            
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
