//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//


import Models
import Dependencies

public struct Search {
    public var add: (_ keyword: String) -> Void
    public var remove: (_ keyword: String) -> Void
    public var getAll: () -> [String]

    /// 최근 검색어
    @UserDefault(key: StringSet.recentSearch, defaultValue: [])
    static var recentKeywords: [String]
}

extension Search {
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

extension Search: DependencyKey {
    public static let liveValue: Search = .default
}

extension DependencyValues {
    public var searches: Search {
        get { self[Search.self] }
        set { self[Search.self] = newValue }
    }
}
