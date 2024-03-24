//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
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
//                학과 추가시 학과가 0개인 경우에는 current를 처음 학과로 설정
                current = departments.first
            }
            
            departments.append(noticeProvider)
            Self.selections = departments
            
        }, remove: { id in
            var departments = Self.selections
            
            Self.selections.removeAll { $0.id == id }
            
            if Self.current?.id == id {
//                삭제한 학과가 현재 선택한 학과일 경우 새로운 학과 정보로 업데이트
                Self.current = nil
                Self.current = Self.selections.first
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
