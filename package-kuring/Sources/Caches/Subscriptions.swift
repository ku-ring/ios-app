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
