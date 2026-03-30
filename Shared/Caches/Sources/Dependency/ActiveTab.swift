//
//  ActiveTab.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/27/25.
//

import Models
import Foundation
import Dependencies
import SwiftUI

public struct ActiveTabDependency {
    public var store: ActiveTabStore
    
    public func callAsFunction() -> TabBarItem {
        store.value
    }
}

extension ActiveTabDependency: DependencyKey {
    public static var liveValue = ActiveTabDependency(store: ActiveTabStore())
}

extension DependencyValues {
    public var activeTab: ActiveTabDependency {
        get { self[ActiveTabDependency.self] }
        set { self[ActiveTabDependency.self] = newValue }
    }
}

@Observable
final public class ActiveTabStore {
    public var value: TabBarItem = .notice
}

public enum TabBarItem: Hashable, CaseIterable {
    case notice
    case calendar
    case campusMap
    case clubs
    case settings
    
    public var title: String {
        switch self {
        case .notice:
            return "공지사항"
        case .calendar:
            return "학사일정"
        case .campusMap:
            return "캠퍼스맵"
        case .clubs:
            return "동아리"
        case .settings:
            return "더보기"
        }
    }
}
