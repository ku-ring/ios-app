//
//  File.swift
//  
//
//  Created by Geon Woo lee on 3/24/24.
//

import UIKit
import Models
import Dependencies
import ComposableArchitecture

public struct Departments {
    /// 학과 추가
    public var add: (_ department: NoticeProvider) -> Void
    /// 학과 삭제
    public var remove: (_ id: String) -> Void
    /// 학과 전체 삭제
    public var removeAll: () -> Void
    /// 사용자가 추가한 모든 학과 리스트
    public var getAll: () -> [NoticeProvider]
    /// 사용자가 구독한 모든 학과 리스트
    public var getSubscribe: () -> [NoticeProvider]
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
    
}

extension Departments {
    public static let `default` = Self(
        add: { department in
            let dto = DepartmentDTO(id: department.id,
                                    name: department.name,
                                    hostPrefix: department.hostPrefix,
                                    korName: department.korName)
            var departments = UserDefaults.standard.object(
                forKey: StringSet.selectedDepartments
            ) as? [DepartmentDTO] ?? []
            
            if departments.isEmpty {
                // 학과 추가시 학과가 0개인 경우에는 current를 처음 학과로 설정
                UserDefaults.standard.set(dto, forKey: StringSet.currentDepartment)
            }
            
            departments.append(dto)
            UserDefaults.standard.set(departments, forKey: StringSet.selectedDepartments)
            
        }, remove: { id in
            var departments = UserDefaults.standard.object(
                forKey: StringSet.selectedDepartments
            ) as? [DepartmentDTO] ?? []
            
            departments.removeAll { $0.id == id }
            
            if let current = departments.first,
               let dto = UserDefaults.standard.object(forKey: StringSet.currentDepartment) as? DepartmentDTO,
               dto.id == id  {
                // 삭제한 학과가 현재 선택한 학과일 경우 새로운 학과 정보로 업데이트
                UserDefaults.standard.set(current, forKey: StringSet.currentDepartment)
            }

        }, removeAll: {
            UserDefaults.standard.removeObject(forKey: StringSet.selectedDepartments)
            UserDefaults.standard.removeObject(forKey: StringSet.currentDepartment)
            
        } , getAll: {
            var departments = UserDefaults.standard.object(
                forKey: StringSet.selectedDepartments
            ) as? [DepartmentDTO] ?? []
            
            let domainModels: [NoticeProvider] = departments.compactMap { dto in
                dto.toDomain()
            }
            
            return domainModels
            
        }, getSubscribe: {
            var departments = UserDefaults.standard.object(
                forKey: StringSet.selectedDepartments
            ) as? [DepartmentDTO]
            
            // 구독한 학과
            let subscriptions = departments?.filter { $0.isSubscribe }
            let domainModels: [NoticeProvider] = subscriptions?.compactMap { dto in
                dto.toDomain()
            } ?? []
            
            return domainModels
            
        }, getCurrent: {
            let dto = UserDefaults.standard.object(forKey: StringSet.currentDepartment) as? DepartmentDTO
            let modainModel = dto?.toDomain()
            
            return modainModel
            
        }, changeCurrent: { department in
            let dto = DepartmentDTO(id: department.id,
                                    name: department.name,
                                    hostPrefix: department.hostPrefix,
                                    korName: department.korName)
            UserDefaults.standard.set(dto, forKey: StringSet.currentDepartment)
            
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
