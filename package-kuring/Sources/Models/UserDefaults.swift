//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

extension UserDefaults {
    /// App Group 을 위한 UserDefaults
    /// ```swift
    /// @AppStorage("subscription.categories", store: .appGroup)
    /// var categoryStrings: [String] = []
    /// ```
    public static let appGroup = UserDefaults(
        suiteName: "group.com.kuring.service"
    )
}

extension String {
    public static let baseString = "com.kuring.sdk"
    
    public static let appVersion = "\(baseString).version.app"
        
    public static let userID = "\(baseString).user.id"
        
    public static let startedAt = "\(baseString).date.start"
    public static let runAt = "\(baseString).date.run"
    public static let lastRunAt = "\(baseString).date.lastrun"
    public static let lastReadNoticeID = "\(baseString).notice.lastread"
    public static let inAppReviewCount = "\(baseString).review.count"
    public static let readNoticeIDs = "\(baseString).notice.readlist"
        
    public static let notificationUserInfo = "\(baseString).notification.userinfo"
    /// 커스텀 알림
    public static let customNotification = "\(baseString).notification.custom"
        
    public static let fcmToken = "\(baseString).token.fcm"
    
    public static let subscriptionToken = "\(baseString).subscription.token"
    
    public static let subscribedCategories = "\(baseString).subscription.categories"
        
    public static let feedbackPlaceholder = "피드백을 남겨주세요..."
    public static let feedbackGuideline = "피드백을 남겨서 앱이 성장하는데에\n큰 기여를 해주세요 🙂"
        
    public static let noticeBookmark = "\(baseString).notice.bookmark"
        
    public static let selectedDepartments = "\(baseString).selected.departments"
    public static let currentDepartment = "\(baseString).current.department"
}
