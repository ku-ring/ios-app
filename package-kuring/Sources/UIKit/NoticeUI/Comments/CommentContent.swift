//
//  CommentContent.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/2/25.
//

import Models
import SwiftUI

/// 하나의 댓글 영역에 대한 뷰
/// ```swift
///    CommentContent(
///         comment: comment,
///         onDelete: onDelete,
///         onReport: onReport
///     )
/// ```
///  - Parameters:
///    - parentId: 메인 댓글의 아이디 (대댓글을 위한)
///    - comment: 댓글 객체
///    - showReplyIcon: 대댓글 아이콘을 보여줄지 정하는 값, 메인 댓글만 대댓글 아이콘
///    - onDelete: 삭제시 이뤄질 액션(API), Comment.isMine == true여야 삭제 가능
///    - onReport: 신고시 이뤄질 액션(API)
struct CommentContent: View {
    @Binding var parentId: Int?
    let comment: Comment
    let showReplyIcon: Bool
    let onDelete: (Comment) -> Void
    let onReport: (Comment) -> Void
    
    init(
        parentId: Binding<Int?>,
        comment: Comment,
        showReplyIcon: Bool = false,
        onDelete: @escaping (Comment) -> Void,
        onReport: @escaping (Comment) -> Void
    ) {
        self._parentId = parentId
        self.comment = comment
        self.showReplyIcon = showReplyIcon
        self.onDelete = onDelete
        self.onReport = onReport
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            headerRow
            contentText
            timestampText
        }
    }
    
    private var headerRow: some View {
        HStack {
            userInfo
            Spacer()
            actionButtons
        }
    }
    
    private var userInfo: some View {
        HStack(spacing: 8) {
            Image("user", bundle: .module)
                .resizable()
                .frame(width: 24, height: 24)
            
            Text(comment.nickName)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.Kuring.body)
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 8) {
            if showReplyIcon {
                Image("comment_circle", bundle: .module)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.Kuring.gray400)
                    .onTapGesture {
                        parentId = parentId == nil ? comment.id : nil
                    }
            }
            
            CommentMenu(
                isOwner: comment.isMine,
                onDelete: { onDelete(comment) },
                onReport: { onReport(comment) }
            )
        }
    }
    
    private var contentText: some View {
        Text(comment.content)
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(Color.Kuring.gray400)
    }
    
    private var timestampText: some View {
        Text(comment.formattedDate)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(Color.Kuring.caption1)
    }
}

#Preview {
    @Previewable @State var parentId: Int?
    
    CommentContent(
        parentId: $parentId,
        comment: CommentData.mock.first!.comment,
        showReplyIcon: true,
        onDelete: { _ in },
        onReport: { _ in }
    )
    .padding(20)
}
