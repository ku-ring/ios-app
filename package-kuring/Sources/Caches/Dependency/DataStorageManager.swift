//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

public struct DataStorageManager {
    public static let shared = DataStorageManager()

    /// 구독한 공지 (대학 및 학과)
    @AppStorage(StringSet.subscribedCategories, store: .init(suiteName: StringSet.appGroup))
    public var subscriptions: Set<NoticeProvider> = []
    
    /// 파이어베이스 토큰
    @AppStorage(StringSet.fcmToken, store: .init(suiteName: StringSet.appGroup))
    public var fcmToken: String = ""
    
    init() {
        migrate()
    }
    
    /// 데이터 이전
    private func migrate() {
        migrate(from: StringSet.subscribedCategories, asType: Set<NoticeProvider>.self)
        migrate(from: StringSet.fcmToken, asType: String.self)
    }
    
    /// `standard`에서 `appGroup`으로 데이터 이동 후 `standard`데이터 지움
    private func migrate<T: Codable>(from key: String, asType type: T.Type) {
        guard let value = UserDefaults.standard.value(forKey: key) as? T else { return }
        guard let userDefault = UserDefaults(suiteName: StringSet.appGroup) else { return }
        userDefault.set(value, forKey: key)
        UserDefaults.standard.set(nil, forKey: key)
    }
}


