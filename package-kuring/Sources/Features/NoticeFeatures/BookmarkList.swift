//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import Models
import ComposableArchitecture

/// ```swift
/// @Bindable var store = Store(initialState: BookmarkListFeature.State())
/// ```
@Reducer
public struct BookmarkListFeature: Reducer {
    @ObservableState
    public struct State: Equatable {
        public var bookmarkedNotices: IdentifiedArrayOf<Notice> = []

        /// 편집시 선택한 북마크 ID
        /// - Note: 순서는 중요하지 않고 중복제거만 중요하므로 `Set` 사용
        public var selectedIDs: Set<Notice.ID> = []

        public var editMode: EditMode = .none

        public var isEditing: Bool { editMode != .none }

        public enum EditMode: Equatable {
            case none
            case editing(deletable: Bool)
        }

        public init() { }
    }

    public enum Action: Equatable, BindableAction {
        /// 바인딩
        case binding(BindingAction<State>)
        /// 화면이 나타날 때
        case onAppear
        /// 편집 버튼 눌렀을 때
        case editButtonTapped
        /// 취소 버튼 눌렀을 때
        case cancelButtonTapped
        /// 전체 선택 버튼 눌렀을 때
        case selectAllButtonTapped
        /// 삭제 버튼 눌렀을 때
        case deleteButtonTapped
    }

    /// 북마크 저장소 디펜던시
    @Dependency(\.bookmarks) public var bookmarks

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onAppear:
                let bookmarkedNotices = try? bookmarks()
                state.bookmarkedNotices = IdentifiedArray(
                    uniqueElements: bookmarkedNotices ?? []
                )
                return .none

            case .binding(\.selectedIDs):
                switch state.editMode {
                case .editing:
                    state.editMode = .editing(deletable: !state.selectedIDs.isEmpty)
                    return .none
                default:
                    return .none
                }

            case .editButtonTapped:
                state.editMode = .editing(deletable: false)
                return .none

            case .cancelButtonTapped:
                state.editMode = .none
                state.selectedIDs.removeAll()

                return .none

            case .selectAllButtonTapped:
                state.editMode = .editing(deletable: true)
                state.selectedIDs = Set(state.bookmarkedNotices.ids)
                return .none

            case .deleteButtonTapped:
                switch state.editMode {
                case .editing(deletable: true):
                    for selectedID in state.selectedIDs {
                        state.bookmarkedNotices.remove(id: selectedID)
                        try? bookmarks.remove(selectedID)
                    }
                    if state.bookmarkedNotices.isEmpty {
                        state.editMode = .none
                        return .none
                    } else {
                        return .send(.binding(.set(\.selectedIDs, [])))
                    }
                default:
                    return .none
                }

            case .binding:
                return .none
            }
        }
    }

    public init() { }
}
