//
//  CommentRow.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/2/25.
//

import Models
import SwiftUI

/// 하나의 댓글 전체를 담고있는 뷰
/// ```swift
/// CommentRow(
///     commentResult: commentResult,
///     onDelete: onDeleteComment,
///     onReport: onReportComment
/// )
/// ```
///  - Parameters:
///    - commentResult: 하나의 댓글 영역 (메인 댓글과 대댓글로 달린 댓글들)을 나타내는 객체
///    - onDelete: 삭제시 이뤄질 액션(API)
///    - onReport: 신고시 이뤄질 액션(API)
struct CommentRow: View {
    let commentResult: CommentResult
    let onDelete: (Comment) -> Void
    let onReport: (Comment) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .frame(height: 2)
            
            mainCommentView
            subCommentsView
        }
    }
    
    private var mainCommentView: some View {
        CommentContent(
            comment: commentResult.comment,
            showReplyIcon: true,
            onDelete: onDelete,
            onReport: onReport
        )
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
    }
    
    private var subCommentsView: some View {
        ForEach(commentResult.subComments, id: \.self) { subComment in
            SubCommentRow(
                comment: subComment,
                onDelete: onDelete,
                onReport: onReport
            )
        }
    }
}

#Preview {
    CommentRow(
        commentResult: CommentData.mock.first!,
        onDelete: { _ in },
        onReport: { _ in }
    )
}
