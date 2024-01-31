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
            self.isBookmarked = isBookmarked
        }
    }

    public enum Action: Equatable {
        case bookmarkButtonTapped
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .bookmarkButtonTapped:
                state.isBookmarked.toggle()
                return .none
            }
        }
    }

    public init() { }
}
