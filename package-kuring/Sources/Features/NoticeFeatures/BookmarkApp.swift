//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import LoginFeatures
import NoticeFeatures
import ComposableArchitecture

@Reducer
public struct BookmarkAppFeature {
    @ObservableState
    public struct State: Equatable {
        /// 루트
        public var bookmarkList = BookmarkListFeature.State()

        public init(
            bookmarkList: BookmarkListFeature.State = BookmarkListFeature.State()
        ) {
            self.bookmarkList = bookmarkList
        }
    }

    public enum Action: Equatable {
        /// 루트 액션 (``BookmarkListFeature/Action``)
        case bookmarkList(BookmarkListFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.bookmarkList, action: \.bookmarkList) {
            BookmarkListFeature()
        }

        Reduce { state, action in
            switch action {
            case .bookmarkList:
                return .none
            }
        }
    }

    public init() { }
}
