//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import Models
import SwiftUI
import ComposableArchitecture

@Reducer
public struct NoticeDetailFeature {
    @ObservableState
    public struct State: Equatable {
        public var notice: Notice
        public var isBookmarked: Bool = false

        public init(notice: Notice, isBookmarked: Bool = false) {
            self.notice = notice
            @Dependency(\.bookmarks) var bookmarks
            do {
                self.isBookmarked = try bookmarks().contains(notice)
            } catch {
                self.isBookmarked = false
            }
        }
    }

    public enum Action: Equatable {
        case bookmarkButtonTapped

        case delegate(Delegate)

        public enum Delegate: Equatable {
            case bookmarkUpdated(Bool)
        }
    }

    @Dependency(\.bookmarks) var bookmarks

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .bookmarkButtonTapped:
                do {
                    if state.isBookmarked {
                        try bookmarks.remove(state.notice.id)
                    } else {
                        try bookmarks.add(state.notice)
                    }
                    state.isBookmarked.toggle()
                } catch {
                    print("북마크 업데이트에 실패했습니다: \(error.localizedDescription)")
                }
                return .none

            case .delegate:
                return .none
            }
        }
        .onChange(of: \.isBookmarked) { _, newValue in
            Reduce { _, _ in
                .send(.delegate(.bookmarkUpdated(newValue)))
            }
        }
    }

    public init() { }
}
