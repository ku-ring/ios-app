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
/// CommentView(
///     comments: CommentData.mock,
///     onSendComment: { comment in
///         store.send(.addComment(comment))
///     },
///     onDeleteComment: { comment in
///         store.send(.deleteComment(comment.id))
///     },
///     onReportComment: { comment in
///         store.send(.reportComment(comment.id))
///     }
/// )
/// ```
///  - Parameters:
///    - commentResult: 하나의 공지에 달린 모든 댓글(메인 댓글과 대댓글로 달린 댓글들)을 나타내는 배열
///    - onSendComment: 댓글 작성시 이뤄질 액션(API)
///    - onDelete: 삭제시 이뤄질 액션(API)
///    - onReport: 신고시 이뤄질 액션(API)
struct CommentView: View {
    @State var commentText: String = ""
    @State private var textFieldHeight: CGFloat = 40
    @FocusState private var isTextFieldFocused: Bool?
    
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
                    Spacer()
                        .frame(height: 60)
                }
            }
            
            if isTextFieldFocused ?? false {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isTextFieldFocused = nil
                    }
            }
            commentInputBar
        }
        .padding(.top, 20)
        .padding(.bottom, 14)
        .background(Color.Kuring.bg)
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
        HStack(alignment: .bottom, spacing: 12) {
            CommentTextField(text: $commentText, calculatedHeight: $textFieldHeight)
                .frame(height: textFieldHeight)
                .focused($isTextFieldFocused, equals: true)
            
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
