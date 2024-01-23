//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

public struct Notice: Codable, Hashable, Identifiable, Equatable {
    public var id: String { "\(category)_\(articleId)" }
    /// e.g., `"5b45b56"`
    public let articleId: String
    /// e.g., `"post_date_1"`
    public let postedDate: String
    /// e.g., `"subject_1"`
    public let subject: String
    /// e.g., `"https://www.konkuk.ac.kr/do/MessageBoard/ArticleRead.do?id=5b45b56"`
    public let url: String
    /// e.g., `"student"`
    public let category: String
    /// e.g., `true`
    public let important: Bool

    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}

extension Notice {
    public static var random: Notice {
        Notice(
            articleId: "5b4924e",
            postedDate: "20211109",
            subject: "교내 출입문 3곳(상허문, 일감문, 건국문) 차량 통제 안내 - 2022학년도 수시모집 논술고사일 - ",
            url: "https://www.konkuk.ac.kr/do/MessageBoard/ArticleRead.do?id=5b4924e",
            category: "normal",
            important: false
        )
    }
}

public struct SearchedNotice: Codable, Hashable {
    public var id: String { baseUrl }
    /// e.g., `"5b45b56"`
    public let articleId: String
    /// e.g., `"post_date_1"`
    public let postedDate: String
    /// e.g., `"subject_1"`
    public let subject: String
    /// e.g., `"https://www.konkuk.ac.kr/do/MessageBoard/ArticleRead.do?id=5b45b56"`
    public let baseUrl: String
    /// e.g., `"student"`
    public let category: String

    public func hash(into hasher: inout Hasher) {
        hasher.combine(baseUrl)
    }

    public var asNotice: Notice {
        Notice(
            articleId: articleId,
            postedDate: postedDate,
            subject: subject,
            url: baseUrl,
            category: category,
            important: false
        )
    }
}
