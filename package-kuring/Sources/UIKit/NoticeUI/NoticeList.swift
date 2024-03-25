//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import ColorSet
import DepartmentUI
import NoticeFeatures
import ComposableArchitecture

struct NoticeList: View {
    @Bindable var store: StoreOf<NoticeListFeature>
    
    var body: some View {
        Section {
            List(self.store.currentNotices, id: \.id) { notice in
                ZStack { // Indicator 표시 제거를 위함
                    NavigationLink(
                        state: NoticeAppFeature.Path.State.detail(
                            NoticeDetailFeature.State(
                                notice: notice,
                                isBookmarked: self.store.bookmarkIDs.contains(notice.id)
                            )
                        )
                    ) {
                        EmptyView()
                    }
                    .opacity(0)
                    
                    VStack(spacing: 0) {
                        NoticeRow(
                            notice: notice,
                            bookmarked: self.store.bookmarkIDs.contains(notice.id)
                        )
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
                                Image(
                                    systemName: self.store.bookmarkIDs.contains(notice.id)
                                    ? "bookmark.slash"
                                    : "bookmark"
                                )
                            }
                            .tint(Color.Kuring.primary)
                        }
                        
                        Divider()
                            .frame(height: 0.25)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .background(Color.Kuring.bg)
            }
            .listStyle(.plain)
        } header: {
            if self.store.provider.category == .학과 {
                VStack(spacing: 0) {
                    DepartmentSelectorLink(
                        department: self.store.provider,
                        isLoading: $store.isLoading.sending(\.loadingChanged)
                    ) {
                        self.store.send(.changeDepartmentButtonTapped)
                    }
                    
                    Divider()
                        .frame(height: 0.25)
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
