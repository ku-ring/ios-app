//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import ActivityUI
import NoticeFeatures
import ComposableArchitecture

public struct NoticeDetailView: View {
    @Bindable var store: StoreOf<NoticeDetailFeature>

    public var body: some View {
        List {
            Section {
                Text(self.store.notice.articleId)

                Text("`notice.articleId`")
            } header: {
                Text("고유번호")
            }

            Section {
                Text(self.store.notice.category)

                Text("`notice.category`")
            } header: {
                Text("공지 카테고리")
            }

            Section {
                Text(self.store.notice.postedDate)

                Text("`notice.postedDate`")
            } header: {
                Text("Posted date")
            }

            Section {
                Text(self.store.notice.subject)

                Text("`notice.subject`")
            } header: {
                Text("공지 제목")
            }

            Section {
                Text(self.store.state.notice.url)

                Text("`notice.url`")
            } header: {
                Text("URL")
            }
        }
        .activitySheet($store.shareItem)
        // TODO: Move to parent
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    self.store.send(.bookmarkButtonTapped)
                } label: {
                    Image(
                        systemName: self.store.isBookmarked
                            ? "bookmark.fill"
                            : "bookmark"
                    )
                }
                
                Button {
                    self.store.send(.shareButtonTapped)
                } label: {
                    Image(systemName: "square.and.arrow.up")
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
        .navigationTitle("Notice Detail View")
    }
}
