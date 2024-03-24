//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//


import Models
import Dependencies

public struct Searches {
    public var add: (_ keyword: String) -> Void
    public var remove: (_ keyword: String) -> Void
    public var getAll: () -> [String]

    /// 최근 검색어
    @UserDefault(key: StringSet.recentSearch, defaultValue: [])
    static var recentKeywords: [String]
}

extension Searches {
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
        })
}

extension Searches: DependencyKey {
    public static let liveValue: Searches = .default
}

extension DependencyValues {
    public var searches: Searches {
        get { self[Searches.self] }
        set { self[Searches.self] = newValue }
    }
}
