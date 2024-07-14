//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

class StringSet {
    static let baseString = "com.kuring.sdk.v2"
    
    static let appVersion = "\(baseString).version.app"
    
    static let userID = "\(baseString).user.id"
    
    static let startedAt = "\(baseString).date.start"
    static let runAt = "\(baseString).date.run"
    static let lastRunAt = "\(baseString).date.lastrun"
    static let lastReadNoticeID = "\(baseString).notice.lastread"
    static let inAppReviewCount = "\(baseString).review.count"
    static let readNoticeIDs = "\(baseString).notice.readlist"
    
    static let notificationUserInfo = "\(baseString).notification.userinfo"
    static let customNotification = "\(baseString).notification.custom"
    
    static let fcmToken = "\(baseString).token.fcm"
    static let subscriptionToken = "\(baseString).subscription.token"
    static let subscribedCategories = "\(baseString).subscription.categories"
    
    static let searcherConnectionQueue = "\(baseString).searcher.connection"
    static let searcherCallbackQueue = "\(baseString).searcher.callback"
    static let searcherOperationQueue = "\(baseString).searcher.operation"
    static let searcherHeartbeatQueue = "\(baseString).searcher.heartbeat"
    
    static let feedbackPlaceholder = "피드백을 남겨주세요..."
    static let feedbackGuideline = "피드백을 남겨서 앱이 성장하는데에\n큰 기여를 해주세요 🙂"
    
    static let noticeBookmark = "\(baseString).notice.bookmark"
    
    static let selectedDepartments = "\(baseString).selected.departments"
    static let currentDepartment = "\(baseString).current.department"
    
    static let isOnboarding = "\(baseString).onboarding"
    
    static let recentSearch = "com.kuring.lite.recent.search"
    
    /// 앱 그룹
    static let appGroup = "group.kuring.serivces"
}
