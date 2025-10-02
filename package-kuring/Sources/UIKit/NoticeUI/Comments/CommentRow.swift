//
//  CommentRow.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/2/25.
//

import Models
import SwiftUI

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
