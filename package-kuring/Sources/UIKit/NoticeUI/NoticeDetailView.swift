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
    
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            WebView(urlString: store.notice.url)
                .background(Color.Kuring.bg)
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showCommentSection) {
                    CommentView(comments: comments)
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
