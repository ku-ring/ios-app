//
//  File.swift
//  
//
//  Created by Geon Woo lee on 3/24/24.
//

import UIKit
import Models
import SwiftUI
import Dependencies

public struct Departments {
    /// 학과 추가
    public var add: (_ department: NoticeProvider) -> Void
    /// 학과 삭제
    public var remove: (_ id: String) -> Void
    /// 학과 전체 삭제
    public var removeAll: () -> Void
    /// 사용자가 추가한 모든 학과 리스트
    public var getAll: () -> [NoticeProvider]
    /// 사용자가 현재 선택한 학과
    public var getCurrent: () -> NoticeProvider?
    /// 사용자가 현재 선택한 학과 변경
    public var changeCurrent: (_ department: NoticeProvider) -> Void
    
    struct DepartmentDTO: Identifiable, Codable {
        var id: String
        /// 학과 이름
        var name: String
        var hostPrefix: String
        var korName: String
        /// 해당 학과 공지 구독 여부
        var isSubscribe: Bool = false
        
        func toDomain() -> NoticeProvider {
            return .init(
                name: self.name,
                hostPrefix: self.hostPrefix,
                korName: self.korName,
                category: .학과
            )
        }
    }
    
    /// 선택한 학과 리스트
    @UserDefault(key: StringSet.selectedDepartments, defaultValue: [])
    static var selections: [NoticeProvider]
    
    /// 선택한 학과 리스트 중 현재 공지에 보여줄 학과
    @UserDefault(key: StringSet.currentDepartment, defaultValue: nil)
    static var current: NoticeProvider?
}

extension Departments {
    public static let `default` = Self(
        add: { noticeProvider in
            var noticeProvider = noticeProvider
            noticeProvider.category = .학과
            
            var departments = Self.selections

            if departments.isEmpty {
//                 학과 추가시 학과가 0개인 경우에는 current를 처음 학과로 설정
                current = departments.first
            }
            
            departments.append(noticeProvider)
            Self.selections = departments
            
        }, remove: { id in
            var departments = Self.selections
            
            Self.selections.removeAll { $0.id == id }
            
            if let current = departments.first,
               Self.current?.id == id  {
                // 삭제한 학과가 현재 선택한 학과일 경우 새로운 학과 정보로 업데이트
                Self.current = current
            }

        }, removeAll: {
            Self.selections.removeAll()
            Self.current = nil
            
        }, getAll: {
            Self.selections
            
        }, getCurrent: {
            Self.current
            
        }, changeCurrent: { noticeProvider in
            Self.current = noticeProvider
            
        }
    )
    
}

extension Departments: DependencyKey {
    public static var liveValue: Departments = .default
}

extension DependencyValues {
    public var departments: Departments {
        get { self[Departments.self] }
        set { self[Departments.self] = newValue }
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
