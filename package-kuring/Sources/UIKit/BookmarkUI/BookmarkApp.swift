//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import NoticeUI
import BookmarkFeatures
import ComposableArchitecture

public struct BookmarkApp: View {
    @Bindable var store: StoreOf<BookmarkAppFeature>

    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            BookmarkList(
                store: store.scope(
                    state: \.bookmarkList,
                    action: \.bookmarkList
                )
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("보관함")

        } destination: { store in
            switch store.state {
            case .detail:
                if let store = store.scope(state: \.detail, action: \.detail) {
                    NoticeDetailView(store: store)
                }
            }
        }
    }

    public init(store: StoreOf<BookmarkAppFeature>) {
        self.store = store
    }
}

#Preview {
    BookmarkApp(
        store: Store(
            initialState: BookmarkAppFeature.State(
                bookmarkList: BookmarkListFeature.State()
            ),
            reducer: { BookmarkAppFeature() }
        )
    )
}
