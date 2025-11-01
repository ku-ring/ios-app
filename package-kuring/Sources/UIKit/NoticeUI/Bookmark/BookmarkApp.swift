//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import LoginUI
import SwiftUI
import NoticeFeatures
import ComposableArchitecture

public struct BookmarkApp: View {
    @Bindable var store: StoreOf<BookmarkAppFeature>
    
    public var body: some View {
        BookmarkList(
            store: store.scope(
                state: \.bookmarkList,
                action: \.bookmarkList
            )
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("보관함")
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
