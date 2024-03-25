//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//


import Models
import Dependencies

public struct RecentSearch {
    public var add: (_ keyword: String) -> Void
    public var remove: (_ keyword: String) -> Void
    public var getAll: () -> [String]

    /// 최근 검색어
    @UserDefault(key: StringSet.recentSearch, defaultValue: [])
    static var recentKeywords: [String]
}

extension RecentSearch {
    public static let `default` = Self(
        add: { keyword in
            var keywords = Self.recentKeywords
            keywords.append(keyword)
            Self.recentKeywords = keywords
            
        }, remove: { keyword in
            var keywords = Self.recentKeywords
            keywords.removeAll { $0 == keyword }
            Self.recentKeywords = keywords
            
        }, getAll: {
            Self.recentKeywords
        }
    )
}

extension RecentSearch: DependencyKey {
    public static let liveValue: RecentSearch = .default
}

extension DependencyValues {
    public var recentSearch: RecentSearch {
        get { self[RecentSearch.self] }
        set { self[RecentSearch.self] = newValue }
    }
}
