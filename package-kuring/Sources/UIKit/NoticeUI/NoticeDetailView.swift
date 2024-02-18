//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import CommonUI
import ActivityUI
import NoticeFeatures
import ComposableArchitecture

public struct NoticeDetailView: View {
    @Bindable var store: StoreOf<NoticeDetailFeature>
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        WebView(urlString: store.notice.url)
            .activitySheet($store.shareItem)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(store.notice.subject)
                        .font(.system(size: 12))
                }
                
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
