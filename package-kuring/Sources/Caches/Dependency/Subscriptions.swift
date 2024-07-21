//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import Foundation
import Dependencies

public struct KuringSubscriptions {
    /// 구독한 공지 리스트에 단일 객체 추가
    public var add: (_ noticeProvider: NoticeProvider) -> Void
    /// 구독한 공지 리스트 업데이트
    public var update: (_ noticeProvider: Set<NoticeProvider>) -> Void
    /// 구독한 공지 리스트에 단일 객체 삭제
    public var remove: (_ noticeProvider: NoticeProvider) -> Void
    /// 구독한 모든 공지 카테고리
    public var getAll: () -> Set<NoticeProvider>
    /// 커스텀 공지 구독 여부
    public var isCustomNotification: () -> Bool
    /// 커스텀 공지 구독 여부 변경
    public var changeCustomNotification: (_ isSubscribe: Bool) -> Void
    
    /// 커스텀 공지 구독 여부 (기본값 true)
    @UserDefault(key: StringSet.customNotification, defaultValue: true)
    static var isCustomNotification: Bool
}

extension KuringSubscriptions {
    public static let `default` = Self(
        add: { noticeProvider in
            var subscriptions = DataStorageManager.shared.subscriptions
            subscriptions.insert(noticeProvider)
            DataStorageManager.shared.subscriptions = subscriptions
            
        }, update: { noticeProviders in
            DataStorageManager.shared.subscriptions = noticeProviders
            
        }, remove: { noticeProvider in
            var subscriptions = DataStorageManager.shared.subscriptions
            subscriptions.remove(noticeProvider)
            DataStorageManager.shared.subscriptions = subscriptions
            
        }, getAll: {
            DataStorageManager.shared.subscriptions
            
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

public struct DataStorageManager {
    public static let shared = DataStorageManager()

    /// 구독한 공지 (대학 및 학과)
    @AppStorage(StringSet.subscribedCategories, store: .init(suiteName: StringSet.appGroup))
    public var subscriptions: Set<NoticeProvider> = []
    
    
    init() {
        print("🥹 마잉그레이션 1번")
        MigrationManager().migrate()
    }
}

struct MigrationManager {
    func migrate() {
        migrate(from: StringSet.subscribedCategories, asType: Set<NoticeProvider>.self, appGroup: StringSet.appGroup)

    }
    
    private func migrate<T: Codable>(from key: String, asType type: T.Type) {
        guard let value = UserDefaults.standard.value(forKey: key) as? T else { return }
        guard let encodedData = try? PropertyListEncoder().encode(value) else { return }
        UserDefaults.standard.set(encodedData, forKey: key)
    }
    
    private func migrate<T: Codable>(from key: String, asType type: T.Type, appGroup: String) {
        guard let userDefault = UserDefaults(suiteName: StringSet.appGroup) else { return }
        guard let value = userDefault.value(forKey: key) as? T else { return }
        guard let encodedData = try? PropertyListEncoder().encode(value) else { return }
        UserDefaults.standard.set(encodedData, forKey: key)
    }
}
