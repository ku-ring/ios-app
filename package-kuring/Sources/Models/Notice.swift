//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

/// 공지
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
    
    public init(articleId: String, postedDate: String, subject: String, url: String, category: String, important: Bool) {
        self.articleId = articleId
        self.postedDate = postedDate
        self.subject = subject
        self.url = url
        self.category = category
        self.important = important
    }
}

// MARK: - Push Notification
extension Notice {
    /// 푸시 알림으로 부터 공지를 생성합니다
    /// ```swift
    /// let userInfo = resposne.notification.request.content.userInfo as? [String: Any]
    /// guard let userInfo else { return }
    /// guard userInfo["type"] == "notice" else { return }
    ///
    /// try Notice(userInfo: userInfo)
    /// ```
    public init(userInfo: [String: Any]) throws {
        guard let articleID = userInfo["articleId"] as? String else {
            throw DecodingError.noArticleID
        }
        guard let postedDate = userInfo["postedDate"] as? String else {
            throw DecodingError.noPostedDate
        }
        guard let subject = userInfo["subject"] as? String else {
            throw DecodingError.noSubject
        }
        guard let baseUrl = userInfo["baseUrl"] as? String else {
            throw DecodingError.noURL
        }
        guard let category = userInfo["category"] as? String else {
            throw DecodingError.noCategory
        }
        let important = userInfo["important"] as? Bool
        
        self.init(
            articleId: articleID,
            postedDate: postedDate,
            subject: subject,
            url: baseUrl,
            category: category,
            important: important ?? false
        )
    }
    
    /// 서버값으로 부터 공지 알림을 디코딩 하지 못했을 때 던지는 에러.
    /// - Note: 현재는 푸시 알림 디코딩에만 사용되고 있습니다.
    public enum DecodingError: Error {
        /// `articleId` 없음
        case noArticleID
        /// `subject` 없음
        case noSubject
        /// `category` 없음
        case noCategory
        /// `postedDate`  없음
        case noPostedDate
        /// URL 정보 없음
        case noURL
    }
}

extension Notice.DecodingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noArticleID:
            "\"articleId\" 키에 해당하는 값이 없습니다"
        case .noSubject:
            "\"subject\" 키에 해당하는 값이 없습니다"
        case .noCategory:
            "\"category\" 키에 해당하는 값이 없습니다"
        case .noPostedDate:
            "\"postedDate\" 키에 해당하는 값이 없습니다"
        case .noURL:
            "\"baseUrl\" 키에 해당하는 값이 없습니다"
        }
    }
}

// MARK: - Test Mock
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

/// 검색된 공지
/// - Note: 서버의 json 데이터의 depth 가 달라 추가된 모델
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
