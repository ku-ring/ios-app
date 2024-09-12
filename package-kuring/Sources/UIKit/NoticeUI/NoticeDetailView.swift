//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import ColorSet
import CommonUI
import EKEventUI
import ActivityUI
import NoticeFeatures
import ComposableArchitecture

public struct NoticeDetailView: View {
    @Bindable var store: StoreOf<NoticeDetailFeature>
    
    var noticeProvider: NoticeProvider? {
        NoticeProvider.univNoticeTypes.first { $0.name == store.notice.category }
        ?? NoticeProvider.departments.first { $0.name == store.notice.category }
    }
    
    public var body: some View {
        WebView(urlString: store.notice.url)
            .background(Color.Kuring.bg)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $store.isPresentedEventView) {
                if let eventStore = store.state.eventStore, let event = store.state.event {
                    EKEventView(
                        eventStore: eventStore,
                        event: event
                    )
                } else {
                    EmptyView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(noticeProvider?.korName ?? "")
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        self.store.send(.calenarButtonTapped)
                    } label: {
                        Image(systemName: "calendar.badge.plus")
                    }
                    Button {
                        self.store.send(.bookmarkButtonTapped)
                    } label: {
                        Image(
                            self.store.isBookmarked
                            ? "bookmark-fill"
                            : "bookmark",
                            bundle: Bundle.notices
                        )
                    }
                    
                    ShareLink(
                        item: store.notice.url
                    ) {
                        Image("share", bundle: Bundle.notices)
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
