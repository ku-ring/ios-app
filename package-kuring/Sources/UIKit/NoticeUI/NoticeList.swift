//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import DepartmentUI
import NoticeFeatures
import ComposableArchitecture

struct NoticeList: View {
    @Bindable var store: StoreOf<NoticeListFeature>

    var body: some View {
        Section {
            List(self.store.currentNotices, id: \.id) { notice in
                NavigationLink(
                    state: NoticeAppFeature.Path.State.detail(
                        NoticeDetailFeature.State(
                            notice: notice,
                            isBookmarked: self.store.bookmarkIDs.contains(notice.id)
                        )
                    )
                ) {
                    NoticeRow(
                        notice: notice,
                        bookmarked: self.store.bookmarkIDs.contains(notice.id)
                    )
                    .listRowInsets(EdgeInsets())
                    .onAppear {
                        let type = self.store.provider
                        let noticeInfo = self.store.noticeDictionary[type]
                        
                        /// 마지막 공지가 보이면 update
                        if noticeInfo?.notices.last == notice {
                            self.store.send(.fetchNotices)
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            self.store.send(.bookmarkTapped(notice))
                        } label: {
                             Image(systemName: self.store.bookmarkIDs.contains(notice.id)
                                   ? "bookmark.slash"
                                   : "bookmark"
                             )
                        }
                        .tint(Color.accentColor)
                    }
                }
            }
            .listStyle(.plain)
        } header: {
            if self.store.provider.category == .학과 {
                DepartmentSelectorLink(
                    department: self.store.provider,
                    isLoading: $store.isLoading.sending(\.loadingChanged)
                ) {
                    self.store.send(.changeDepartmentButtonTapped)
                }
            } else {
                EmptyView()
            }
        }
        .navigationTitle("")
    }
}

#Preview {
    NoticeList(
        store: .init(
            initialState: NoticeListFeature.State(),
            reducer: { NoticeListFeature() }
        )
    )
}
