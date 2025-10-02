//
//  SubCommentRow.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/2/25.
//

import Models
import SwiftUI

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
