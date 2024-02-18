//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import Models
import SwiftUI
import ActivityUI
import ComposableArchitecture

@Reducer
public struct NoticeDetailFeature {
    @ObservableState
    public struct State: Equatable {
        public var notice: Notice
        public var isBookmarked: Bool = false
        public var shareItem: ActivityItem? = nil

        public init(notice: Notice, isBookmarked: Bool = false) {
            self.notice = notice
            self.isBookmarked = isBookmarked
        }
    }

    public enum Action: BindableAction, Equatable {
        case bookmarkButtonTapped
        case shareButtonTapped
        case backButtonTapped
        
        case binding(BindingAction<State>)

        case delegate(Delegate)

        public enum Delegate: Equatable {
            case bookmarkUpdated(_ notice: Notice, _ isBookmarkd: Bool)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
//    /// 북마크 저장소 디펜던시
//    @Dependency(\.bookmarks) public var bookmarks
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .bookmarkButtonTapped:
                state.isBookmarked.toggle()
//                do {
//                    if state.isBookmarked {
//                        try bookmarks.add(state.notice)
//                    } else {
//                        try bookmarks.remove(state.notice.id)
//                    }
//                } catch {
//                    print("북마크 업데이트에 실패했어요: \(error.localizedDescription)")
//                }
                return .none
                
            case .shareButtonTapped:
                state.shareItem = ActivityItem(
                    items: state.notice.url
                )
                return .none
                
            case .backButtonTapped:
                return .run { _ in await self.dismiss() }
                
            case .delegate:
                return .none
            }
        }
        .onChange(of: \.isBookmarked) { _, newValue in
            Reduce { state, _ in
                return .send(.delegate(.bookmarkUpdated(state.notice, newValue)))
            }
        }
    }
    
    public init() { }
}
