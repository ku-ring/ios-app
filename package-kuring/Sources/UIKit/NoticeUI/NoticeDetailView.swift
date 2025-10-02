//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import ColorSet
import CommonUI
import NoticeEKEventUI
import ActivityUI
import NoticeFeatures
import ComposableArchitecture

public struct NoticeDetailView: View {
    @Bindable var store: StoreOf<NoticeDetailFeature>
    @State private var showCommentSection: Bool = false
    
    var noticeProvider: NoticeProvider? {
        NoticeProvider.univNoticeTypes.first { $0.name == store.notice.category }
        ?? NoticeProvider.departments.first { $0.name == store.notice.category }
    }
    
    let comments: [CommentResult] = [
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
                    content: "쿠링 댓글 예시용22\n쿠링 댓글 예시용22\n쿠링 댓글 예시용22",
                    isMine: true,
                    destroyedAt: nil,
                    createdAt: "2025-03-09T17:27:54.861844",
                    updatedAt: "2025-03-10T11:42:36.60882"
                ),
                .init(
                    parentId: 1,
                    id: 4,
                    userId: 234,
                    nickName: "건덕이",
                    noticeId: 67,
                    content: "쿠링 댓글 예시용33\n쿠링 댓글 예시용33\n쿠링 댓글 예시용33",
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
            ), subComments: [])
    ]
    
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            WebView(urlString: store.notice.url)
                .background(Color.Kuring.bg)
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showCommentSection) {
                    CommentView(
                        comments: comments,
                        onSendComment: { comment in
                            
                        },
                        onDeleteComment: { comment in
                            
                        },
                        onReportComment: { comment in
                            
                        }
                    )
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
                }
                .sheet(isPresented: $store.isPresentedEventView) {
                    EKEventView()
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(noticeProvider?.korName ?? "")
                    }
                    
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button {
                            self.store.send(.calendarButtonTapped)
                        } label: {
                            Image(systemName: "calendar.badge.plus")
                        }
                        Button {
                            self.store.send(.bookmarkButtonTapped)
                        } label: {
                            Image(self.store.isBookmarked
                                  ? "bookmark-fill"
                                  : "bookmark", bundle: Bundle.notices
                            )
                        }
                        
                        ShareLink(
                            item: store.notice.url
                        ) {
                            Image("share", bundle: Bundle.notices)
                        }
                    }
                }
            
            Image("comment_button", bundle: .module)
                .resizable()
                .frame(width: 72, height: 72)
                .padding(20)
                .onTapGesture {
                    showCommentSection = true
                }
        }
    }
    
    public init(store: StoreOf<NoticeDetailFeature>) {
        self.store = store
    }
}

#Preview {
    NavigationStack {
        NoticeDetailView(
            store: Store(
                initialState: NoticeDetailFeature.State(notice: Notice.random),
                reducer: { NoticeDetailFeature() }
            )
        )
    }
}
