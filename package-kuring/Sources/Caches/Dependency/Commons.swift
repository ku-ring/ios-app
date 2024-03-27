//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import Dependencies

public struct Commons {
    
    // MARK: - 시스템 영역
    
    /// 현재 앱 버전
    public var appVersion: () -> String
    /// 온보딩을 완료했는지 여부
    public var isCompleteOnboarding: () -> Bool
    /// 온보딩을 완료한 상태로 변경
    public var completeOnboarding: () -> Void
    
    @AppStorage(StringSet.isOnboarding)
    static var isOnboardingCompleted: Bool = false
    
    // MARK: - 인앱 리뷰
    
    /// 인앱 리뷰 카운트
    public var getInAppReviewCount: () -> Int
    /// 인앱 리뷰 카운트 증가
    public var increaseInAppReviewCount: () -> Void
    
    @AppStorage(StringSet.inAppReviewCount)
    static var inAppReviewCount: Int = 0
    
    // MARK: - 공지
    
    /// 사용자가 읽은 공지 id
    public var getReadNoticeIds: () -> [String]
    /// 사용자가 읽은 공지 추가
    public var addReadNoticeId: (_ id: String) -> Void
    
    @UserDefault(key: StringSet.readNoticeIDs, defaultValue: [])
    static var readNoticeIds: [String]
    
}

extension Commons {
    public static let `default` = Self(
        appVersion: {
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
            return appVersion as? String ?? "0.0.0"
            
        }, isCompleteOnboarding: {
            Self.isOnboardingCompleted
            
        }, completeOnboarding: {
            Self.isOnboardingCompleted = true
            
        }, getInAppReviewCount: {
            Self.inAppReviewCount
            
        }, increaseInAppReviewCount: {
            var count = Self.inAppReviewCount
            count += 1
            Self.inAppReviewCount = count
            
        }, getReadNoticeIds: {
            Self.readNoticeIds
            
        }, addReadNoticeId: { id in
            var notices = Self.readNoticeIds
            notices.append(id)
            Self.readNoticeIds = notices
            
        }
    )

}

extension Commons: DependencyKey {
    public static var liveValue: Commons = .default
}

extension DependencyValues {
    public var commons: Commons {
        get { self[Commons.self] }
        set { self[Commons.self] = newValue }
    }
}
