//
//  SubCommentRow.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/2/25.
//

import Models
import SwiftUI

/// 대댓글을 담고있는 뷰
/// ```swift
/// SubCommentRow(
///     commentResult: commentResult,
///     onDelete: onDeleteComment,
///     onReport: onReportComment
/// )
/// ```
///  - Parameters:
///    - comment: 하나의 대댓글을 나타내는 객체
///    - onDelete: 삭제시 이뤄질 액션(API)
///    - onReport: 신고시 이뤄질 액션(API)
struct SubCommentRow: View {
    let comment: Comment
    let onDelete: (Comment) -> Void
    let onReport: (Comment) -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 3) {
            replyIcon
            
            CommentContent(
                comment: comment,
                onDelete: onDelete,
                onReport: onReport
            )
            .padding(.vertical, 9)
            .padding(.horizontal, 17)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.Kuring.gray100)
            )
        }
        .padding(.top, 5)
        .padding([.bottom, .horizontal], 7)
    }
    
    private var replyIcon: some View {
        Image("reply_arrow", bundle: .module)
            .resizable()
            .frame(width: 24, height: 24)
            .padding(.top, 11)
    }
}
