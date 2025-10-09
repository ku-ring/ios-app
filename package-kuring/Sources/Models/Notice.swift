//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

/// 공지
public struct Notice: Codable, Identifiable, Hashable, Equatable {
    /// e.g., `76473`
    public var id: Int
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
    /// e.g., `67`
    public let commentCount: Int

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public init(id: Int, articleId: String, postedDate: String, subject: String, url: String, category: String, important: Bool, commentCount: Int) {
        self.id = id
        self.articleId = articleId
        self.postedDate = postedDate
        self.subject = subject
        self.url = url
        self.category = category
        self.important = important
        self.commentCount = commentCount
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
        guard let id = userInfo["id"] as? Int else {
            throw DecodingError.noID
        }
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
        let commentCount = userInfo["commentCount"] as? Int
        
        self.init(
            id: id,
            articleId: articleID,
            postedDate: postedDate,
            subject: subject,
            url: baseUrl,
            category: category,
            important: important ?? false,
            commentCount: commentCount ?? 0
        )
    }
    
    /// 서버값으로 부터 공지 알림을 디코딩 하지 못했을 때 던지는 에러.
    /// - Note: 현재는 푸시 알림 디코딩에만 사용되고 있습니다.
    public enum DecodingError: Error {
        /// `id` 없음
        case noID
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
        case .noID:
            "\"id\" 키에 해당하는 값이 없습니다"
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
            id: 123,
            articleId: "5389",
            postedDate: "2024-02-21",
            subject: "2024학년도 신입생 입학식 개최 안내",
            url: "https://www.konkuk.ac.kr/bbs/konkuk/234/5389/artclView.do",
            category: "bachelor",
            important: false,
            commentCount: 0
        )
    }
}

/// 검색된 공지
/// - Note: 서버의 json 데이터의 depth 가 달라 추가된 모델
public struct SearchedNotice: Codable, Hashable {
    public var id: Int
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
    /// e.g., `13`
    public let commentCount: Int

    public func hash(into hasher: inout Hasher) {
        hasher.combine(baseUrl)
    }

    public var asNotice: Notice {
        Notice(
            id: id,
            articleId: articleId,
            postedDate: postedDate,
            subject: subject,
            url: baseUrl,
            category: category,
            important: false,
            commentCount: commentCount
        )
    }
}
