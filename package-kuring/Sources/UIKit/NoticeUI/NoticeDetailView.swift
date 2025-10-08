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
    @AppStorage("com.kuring.sdk.v2.token.accessToken") private var accessToken: String = ""
    
    var noticeProvider: NoticeProvider? {
        NoticeProvider.univNoticeTypes.first { $0.name == store.notice.category }
        ?? NoticeProvider.departments.first { $0.name == store.notice.category }
    }
    
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            WebView(urlString: store.notice.url)
                .background(Color.Kuring.bg)
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $store.showCommentSection) {
                    CommentView(
                        comments: store.comments?.comments ?? [],
                        onSendComment: { comment, parentId in
                            store.send(.addComment(content: comment, parentId: parentId))
                        },
                        onDeleteComment: { comment in
                            store.send(.deleteCommentTapped(noticeId: store.notice.id, commentId: comment.id))
                        },
                        onReportComment: { comment in
                            store.send(.pushToReportComment(commentId: comment.id, content: comment.content))
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
                .alert(
                    store: store.scope(
                        state: \.$alert,
                        action: \.alert
                    )
                )
                .onAppear {
                    guard accessToken != "" else {
                        return
                    }
                    store.send(.getComments)
                }
            
            ZStack {
                Circle()
                    .fill(Color.Kuring.primary)
                    .frame(width: 64, height: 64)
                    .shadow(radius: 5)
                
                VStack(alignment: .center) {
                    Image("comment_icon", bundle: .module)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                    Text("댓글")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white)
                }
                .padding(.top, 5)
            }
            .padding(.bottom, 20)
            .padding(.trailing, 16)
            .onTapGesture {
                if accessToken == "" {
                    store.send(.showNeedsLoginAlert)
                } else {
                    store.send(.toggleCommentSection)
                }
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
