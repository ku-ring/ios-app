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
        ScrollView {
            VStack(spacing: 0) {
                if self.store.provider.category == .학과 {
                    DepartmentSelectorLink(
                        department: self.store.provider,
                        isLoading: $store.isLoading.sending(\.loadingChanged)
                    ) {
                        self.store.send(.changeDepartmentButtonTapped)
                    }
                }
                
                ForEach(self.store.currentNotices, id: \.id) { notice in
                    ZStack {
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
                        
                        Section {
                            VStack(spacing: 0) {
                                NoticeRow(
                                    notice: notice,
                                    bookmarked: self.store.bookmarkIDs.contains(notice.id)
                                )
                                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
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
                                    .tint(Color.accentColor)
                                }
                                
                                Divider()
                                    .frame(height: 1)
                            }
                            
                        }
                        .navigationTitle("")
                        
                    }
                }
            }
        }
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
