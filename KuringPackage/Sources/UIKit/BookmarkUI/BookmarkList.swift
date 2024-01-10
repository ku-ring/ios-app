import SwiftUI
import NoticeUI
import NoticeFeatures
import BookmarkFeatures
import ComposableArchitecture

public struct BookmarkList: View {
    @Bindable var store: StoreOf<BookmarkListFeature>
    
    public var body: some View {
        List {
            ForEach(self.store.bookmarkedNotices, id: \.id) { notice in
                HStack {
                    NoticeRow(notice: notice)
                        .background {
                            NavigationLink(
                                state: BookmarkAppFeature.Path.State.detail(
                                    NoticeDetailFeature.State(notice: notice)
                                )
                            ) {
                                EmptyView()
                            }
                            .opacity(0)
                        }
                    .disabled(store.editMode != .none)
                    
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
                        .foregroundStyle(Color.accentColor)
                    }
                    .opacity(store.editMode == .none ? 0 : 1)
                    .disabled(store.editMode == .none)
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    store.editMode = .none
                } label: {
                    Text("취소")
                }
                .disabled(store.selectedIDs.isEmpty)
                .opacity(store.editMode == .none ? 0 : 1)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    switch store.editMode {
                    case .none:
                        store.send(.editButtonTapped)
                    case .editing:
                        store.send(.selectAllButtonTapped)
                    }
                } label: {
                    switch store.editMode {
                    case .none:
                        Text("편집")
                    case .editing:
                        Text("전체 선택")
                    }
                }
                .foregroundStyle(Color.accentColor)
            }
        }
    }
}

#Preview {
    NavigationStack {
        BookmarkList(
            store: Store(
                initialState: BookmarkListFeature.State(
                    bookmarkedNotices: [.random]
                ),
                reducer: { BookmarkListFeature() }
            )
        )
    }
}
