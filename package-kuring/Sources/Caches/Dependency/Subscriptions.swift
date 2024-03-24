//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import Foundation
import Dependencies

struct Subscriptions {
    public var add: (_ noticeProvider: NoticeProvider) -> Void
    public var remove: (_ noticeProvider: NoticeProvider) -> Void
    public var getAll: () -> [NoticeProvider]
    
    @UserDefault(key: StringSet.subscribedCategories, defaultValue: [])
    static var subscriptions: [NoticeProvider]
    
    // TODO: - 마이그레이션 체크를 위한 키
    @UserDefault(key: "subscriptions.v2.0.0", defaultValue: false)
    static var isMigration: Bool
}

extension Subscriptions {
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
            
        })

}
