//
//  CommentContent.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/2/25.
//

import Models
import SwiftUI

struct CommentContent: View {
    let comment: Comment
    let showReplyIcon: Bool
    let onDelete: (Comment) -> Void
    let onReport: (Comment) -> Void
    
    init(
        comment: Comment,
        showReplyIcon: Bool = false,
        onDelete: @escaping (Comment) -> Void,
        onReport: @escaping (Comment) -> Void
    ) {
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
                    .resizable()
                    .frame(width: 24, height: 24)
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
