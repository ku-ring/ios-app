//
//  CommentView.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/1/25.
//

import Models
import SwiftUI
import ColorSet

/// 댓글 전체 영역, sheet 형식으로 띄워줌
/// ```swift
///  CommentView()
/// ```
struct CommentView: View {
    @State var commentText: String = ""
    @State private var textFieldHeight: CGFloat = 40
    
    let comments: [CommentResult]
    let onSendComment: (String) -> Void
    let onDeleteComment: (Comment) -> Void
    let onReportComment: (Comment) -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical) {
                VStack {
                    headerView
                    commentsListView
                }
            }
            commentInputBar
        }
        .padding(.top, 20)
        .padding(.bottom, 14)
    }
    
    private var headerView: some View {
        Text("댓글")
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(Color.Kuring.title)
    }
    
    private var commentsListView: some View {
        VStack(spacing: 0) {
            ForEach(comments, id: \.self) { commentResult in
                CommentRow(
                    commentResult: commentResult,
                    onDelete: onDeleteComment,
                    onReport: onReportComment
                )
            }
        }
    }
    
    private var commentInputBar: some View {
        HStack(spacing: 12) {
            CommentTextField(text: $commentText, calculatedHeight: $textFieldHeight)
                .frame(height: textFieldHeight)
            
            sendButton
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .background(Color.Kuring.bg)
    }
     
    private var sendButton: some View {
        Button {
            guard !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return
            }
            onSendComment(commentText)
            commentText = ""
        } label: {
            Circle()
                .fill(Color.black.opacity(0.8))
                .frame(width: 40, height: 40)
                .overlay {
                    Image("arrow_up", bundle: .module)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
        }
    }
}

#Preview {
    CommentView(
        comments: CommentData.mock,
        onSendComment: { comment in
            
        },
        onDeleteComment: { comment in
            
        },
        onReportComment: { comment in
            
        }
    )
}
