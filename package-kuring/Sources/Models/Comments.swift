//
//  Comments.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/26/25.
//

import Foundation

public struct CommentData: Codable {
    public let comments: [CommentResult]
    public let endCursor: String
    public let hasNext: Bool
    
    public init(comments: [CommentResult], endCursor: String, hasNext: Bool) {
        self.comments = comments
        self.endCursor = endCursor
        self.hasNext = hasNext
    }
}

public struct CommentResult: Codable {
    public let comment: Comment
    public let subComments: [Comment]
}

public struct Comment: Codable {
    public let id, parentId, userId: Int
    public let nickName: String
    public let noticeId: Int
    public let content: String
    public let isMine: Bool
    public let destroyedAt, createdAt, updatedAt: String
}

/// 댓글 추가, 수정할때 서버로 보내는 댓글 정보
public struct CommentRequest: Encodable {
    public let content: String
    public let parentId: Int?
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
        
        // nil이 아닐때만 encode
        if let parentId = parentId {
            try container.encode(parentId, forKey: .parentId)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case content, parentId
    }
    
    public init(content: String, parentId: Int?) {
        self.content = content
        self.parentId = parentId
    }
}

/// 댓글 신고할때 서버로 보내는 댓글
public struct ReportCommentRequest: Encodable {
    public let targetId: Int
    public let reportType: ReportType
    public let content: String

    public enum ReportType: String, Encodable {
        case COMMENT
    }
    
    public init(targetId: Int, reportType: ReportType, content: String) {
        self.targetId = targetId
        self.reportType = reportType
        self.content = content
    }
}
