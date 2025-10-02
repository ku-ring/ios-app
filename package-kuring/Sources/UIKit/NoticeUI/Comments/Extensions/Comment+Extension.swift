//
//  Comment+Extension.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/2/25.
//

import Models
import Foundation

extension Comment {
    var parsedDate: Date? {
        DateFormatter.isoDateFormatter.date(from: self.createdAt)
    }
    
    var formattedDate: String {
        guard let date = parsedDate else {
            return createdAt
        }
        return DateFormatter.commentDateFormatter.string(from: date)
    }
}

extension CommentData {
    public static let mock: [CommentResult] = [
        .init(
            comment: .init(
                parentId: nil,
                id: 1,
                userId: 123,
                nickName: "쿠링님",
                noticeId: 67,
                content: "쿠링 댓글 예시용\n쿠링 댓글 예시용\n쿠링 댓글 예시용",
                isMine: true,
                destroyedAt: nil,
                createdAt: "2025-03-09T17:21:54.861844",
                updatedAt: "2025-03-10T11:42:36.60882"
            ),
            subComments: [
                .init(
                    parentId: 1,
                    id: 3,
                    userId: 234,
                    nickName: "건덕이",
                    noticeId: 67,
                    content: "꿱끄ㅞㄱ",
                    isMine: true,
                    destroyedAt: nil,
                    createdAt: "2025-03-09T17:27:54.861844",
                    updatedAt: "2025-03-10T11:42:36.60882"
                ),
                .init(
                    parentId: 1,
                    id: 4,
                    userId: 234,
                    nickName: "마크",
                    noticeId: 67,
                    content: "저는 사실\n최첨단\nAI 입니다",
                    isMine: true,
                    destroyedAt: nil,
                    createdAt: "2025-03-09T17:44:54.861844",
                    updatedAt: "2025-03-10T11:52:36.60882"
                )
            ]
        ),
        .init(
            comment: .init(
                parentId: nil,
                id: 2,
                userId: 123,
                nickName: "쿠링님",
                noticeId: 67,
                content: "쿠링 댓글 예시용44\n쿠링 댓글 예시용44\n쿠링 댓글 예시용44",
                isMine: true,
                destroyedAt: nil,
                createdAt: "2025-03-09T17:07:54.861844",
                updatedAt: "2025-03-10T11:17:36.60882"
            ), subComments: [
                .init(
                    parentId: 2,
                    id: 5,
                    userId: 162,
                    nickName: "스티브 잡스",
                    noticeId: 67,
                    content: "내 사업 모델은 비틀즈야",
                    isMine: false,
                    destroyedAt: nil,
                    createdAt: "2025-03-012T17:44:54.861844",
                    updatedAt: "2025-03-012T17:55:54.861844"
                )
            ]
        )
    ]
}
