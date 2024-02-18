//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import ComposableArchitecture
import Models

@Reducer
public struct BookmarkAppFeature {
    @ObservableState
    public struct State: Equatable {
        // MARK: 네비게이션

        /// 루트
        public var bookmarkList = BookmarkListFeature.State()
        /// 스택 네비게이션
        public var path = StackState<Path.State>()

        public init(
            bookmarkList: BookmarkListFeature.State = BookmarkListFeature.State(),
            path: StackState<Path.State> = StackState<Path.State>()
        ) {
            self.bookmarkList = bookmarkList
            self.path = path
        }
    }

    public enum Action {
        /// 루트 액션 (``BookmarkListFeature/Action``)
        case bookmarkList(BookmarkListFeature.Action)

        /// 스택 네비게이션 액션 (``BookmarkAppFeature/Path/Action``)
        case path(StackAction<Path.State, Path.Action>)
        
        case updateBookmarks(_ notice: Notice, _ isBookmarked: Bool)
    }
    
    @Dependency(\.bookmarks) var bookmarks

    public var body: some ReducerOf<Self> {
        Scope(state: \.bookmarkList, action: \.bookmarkList) {
            BookmarkListFeature()
        }

        Reduce { _, action in
            switch action {
            case .path:
                return .none

            case .bookmarkList:
                return .none
                
            case let .updateBookmarks(notice, isBookmarked):
                do {
                    if isBookmarked {
                        try bookmarks.add(notice)
                    } else {
                        try bookmarks.remove(notice.id)
                    }
                } catch {
                    print("북마크 업데이트에 실패했어요: \(error.localizedDescription)")
                }
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }

    public init() { }
}
