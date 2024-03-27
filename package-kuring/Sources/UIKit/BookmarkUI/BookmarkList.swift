//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import ColorSet
import NoticeUI
import NoticeFeatures
import BookmarkFeatures
import ComposableArchitecture

public struct BookmarkList: View {
    @Bindable var store: StoreOf<BookmarkListFeature>

    public var body: some View {
        ZStack(alignment: .bottom) {
            Color.Kuring.bg.ignoresSafeArea()
            
            if store.bookmarkedNotices.isEmpty {
                VStack {
                    Spacer()
                    Text("보관된 공지사항이 없습니다.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.Kuring.body)
                    Spacer()
                }
            } else {
                List {
                    ForEach(self.store.bookmarkedNotices, id: \.id) { notice in
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                NoticeRow(
                                    notice: notice,
                                    bookmarked: true,
                                    rowType: store.isEditing
                                    ? NoticeRow.NoticeRowType.none
                                    : nil
                                )
                                .background {
                                    NavigationLink(
                                        state: BookmarkAppFeature.Path.State.detail(
                                            NoticeDetailFeature.State(
                                                notice: notice,
                                                isBookmarked: true
                                            )
                                        )
                                    ) {
                                        EmptyView()
                                    }
                                    .opacity(0)
                                }
                                .disabled(store.editMode != .none)
                                
                                if store.isEditing {
                                    Button {
                                        if store.selectedIDs.contains(notice.id) {
                                            store.selectedIDs.remove(notice.id)
                                        } else {
                                            store.selectedIDs.insert(notice.id)
                                        }
                                    } label: {
                                        Image(
                                            systemName: store.selectedIDs.contains(notice.id)
                                            ? "checkmark.circle.fill"
                                            : "circle"
                                        )
                                        .foregroundStyle(
                                            store.selectedIDs.contains(notice.id)
                                            ? Color.Kuring.primary
                                            : Color.Kuring.gray200
                                        )
                                    }
                                    .padding(.trailing, 18)
                                }
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

                if store.editMode != .none {
                    Button {
                        store.send(.deleteButtonTapped)
                    } label: {
                        topBlurButton(
                            "삭제하기",
                            fontColor: store.selectedIDs.isEmpty
                            ? Color.Kuring.caption1
                            : .white,
                            backgroundColor: store.selectedIDs.isEmpty
                            ? Color.Kuring.gray200
                            : Color.Kuring.primary
                        )
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .onAppear { store.send(.onAppear) }
        .toolbar(
            store.isEditing ? .hidden : .visible,
            for: .tabBar
        )
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    store.send(.cancelButtonTapped)
                } label: {
                    Text("취소")
                }
                .foregroundStyle(.primary)
                .opacity(store.isEditing ? 1 : 0)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.send(
                        store.isEditing
                            ? .selectAllButtonTapped
                            : .editButtonTapped
                    )
                } label: {
                    Text(
                        store.isEditing
                            ? "전체 선택"
                            : "편집"
                    )
                }
                .disabled(store.bookmarkedNotices.isEmpty)
                .foregroundStyle(Color.Kuring.primary)
            }
        }
    }

    private func topBlurButton(_ title: String, fontColor: Color, backgroundColor: Color) -> some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(fontColor)
            Spacer()
        }
        .padding(.horizontal, 50)
        .padding(.vertical, 16)
        .frame(height: 50, alignment: .center)
        .background(backgroundColor)
        .cornerRadius(100)
        .background {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.Kuring.bg.opacity(0.1),
                    Color.Kuring.bg
                ]),
                startPoint: .top, endPoint: .bottom
            )
            .offset(x: 0, y: -32)
        }
    }
}

#Preview {
    TabView {
        NavigationStack {
            BookmarkList(
                store: Store(
                    initialState: BookmarkListFeature.State(),
                    reducer: { BookmarkListFeature() }
                )
            )
        }
        .tabItem {
            Image(systemName: "archivebox")

            Text("공지보관함")
        }
    }
}
