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

        public init(notice: Notice, isBookmarked: Bool? = nil) {
            @Dependency(\.bookmarks) var bookmarks
            self.notice = notice
            if let isBookmarked {
                self.isBookmarked = isBookmarked
                return
            }
            do {
                self.isBookmarked = try bookmarks().contains { $0.id == notice.id }
            } catch {
                self.isBookmarked = false
            }
        }
    }

    public enum Action: BindableAction, Equatable {
        case bookmarkButtonTapped
        case shareButtonTapped
        
        case binding(BindingAction<State>)

        case delegate(Delegate)

        public enum Delegate: Equatable {
            case bookmarkUpdated(_ notice: Notice, _ isBookmarkd: Bool)
        }
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .bookmarkButtonTapped:
                state.isBookmarked.toggle()
                return .none
                
            case .shareButtonTapped:
                state.shareItem = ActivityItem(
                    items: state.notice.url
                )
                return .none
                
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
