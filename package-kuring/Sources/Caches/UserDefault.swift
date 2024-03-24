//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    let storage: UserDefaults

    var wrappedValue: T {
        get {
            guard let data = self.storage.object(forKey: self.key) as? Data else { return defaultValue }
            return (try? PropertyListDecoder().decode(T.self, from: data)) ?? self.defaultValue
        }
        set {
            let encodedData = try? PropertyListEncoder().encode(newValue)
            self.storage.set(encodedData, forKey: self.key)
        }
    }

    init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
}

class StringSet {
    static let baseString = "com.kuring.sdk"
    
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
}
