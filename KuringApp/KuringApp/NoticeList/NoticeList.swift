//
//  NoticeContentView.NoticeList.swift
//  KuringApp
//
//  Created by 이재성 on 11/25/23.
//

import SwiftUI
import ComposableArchitecture

struct NoticeList: View {
    let store: StoreOf<NoticeListFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            let noticeType = viewStore.provider
            let notices = viewStore.noticeDictionary[noticeType]?.notices
            
            Section {
                List(notices ?? [], id: \.id) { notice in
                    NavigationLink(
                        state: NoticeAppFeature.Path.State.detail(
                            NoticeDetailFeature.State(notice: notice)
                        )
                    ) {
                        NoticeRow(notice: notice)
                            .listRowInsets(EdgeInsets())
                            .onAppear {
                                let type = viewStore.provider
                                let noticeInfo = viewStore.noticeDictionary[type]
                                
                                /// 마지막 공지가 보이면 update
                                if noticeInfo?.notices.last == notice {
                                    viewStore.send(.fetchNotices)
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    viewStore.send(.bookmarkTapped(notice))
                                } label: {
                                    Image(systemName: "bookmark.slash")
                                    // Image(systemName: isBookmark ? "bookmark.slash" : "bookmark")
                                }
                                .tint(Color.accentColor)
                            }
                    }
                }
                .listStyle(.plain)
            } header: {
                if viewStore.provider.category == .학과 {
                    DepartmentSelectorLink(
                        department: viewStore.provider,
                        isLoading: viewStore.$isLoading
                    ) {
                        viewStore.send(.changeDepartmentButtonTapped)
                    }
                } else {
                    EmptyView()
                }
            }
        }
    }
}
