//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import Models
import SwiftUI
import EventKit
import ActivityUI
import ComposableArchitecture

@Reducer
public struct NoticeDetailFeature {
    @ObservableState
    public struct State: Equatable {
        public var notice: Notice
        public var comments: CommentData?
        public var isBookmarked: Bool = false
        public var isPresentedEventView: Bool = false

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
        case onAppear
        /// 댓글 GET~
        case getComments
        case getCommentsResponse(Result<CommentData, CommentsError>)
        /// 댓글 추가
        case addComment(content: String, parentId: Int?)
        case addCommentResponse(Result<Bool, CommentsError>)
        /// 댓글 삭제
        case deleteComment(noticeId: Int, commentId: Int)
        case deleteCommentResponse(Result<Bool, CommentsError>)
        /// 댓글 신고
        case reportComment(commentId: Int, content: String)
        case reportCommentResponse(Result<Bool, CommentsError>)
        
        case bookmarkButtonTapped
        case calendarButtonTapped
        case presentEventView
        
        case binding(BindingAction<State>)

        case delegate(Delegate)

        public enum Delegate: Equatable {
            case bookmarkUpdated(_ notice: Notice, _ isBookmarked: Bool)
        }
        
        public enum CommentsError: Error, Equatable {
            case error(String)
            
            public static func == (lhs: CommentsError, rhs: CommentsError) -> Bool {
                switch (lhs, rhs) {
                case let (.error(lmsg), .error(rmsg)):
                    return lmsg == rmsg
                }
            }
        }
    }
    
    @Dependency(\.kuringLink) private var kuringLink
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .onAppear:
                return .send(.getComments)
            case .getComments:
                return .run { [notice = state.notice] send in
                    do {
                        let result = try await kuringLink.getComments(notice.id, nil, nil)
                        await send(.getCommentsResponse(.success(result)))
                    } catch {
                        await send(.getCommentsResponse(.failure(.error(error.localizedDescription))))
                    }
                }
            case let .getCommentsResponse(result):
                switch result {
                case .success(let comments):
                    state.comments = comments
                    return .none
                case let .failure(error):
                    print("Get comment response error: \(error)")
                    return .none
                }
            case .addComment(let content, let parentId):
                return .run { [notice = state.notice] send in
                    do {
                        try await kuringLink.addComment(notice.id, content, parentId)
                        await send(.addCommentResponse(.success(true)))
                    } catch {
                        await send(.addCommentResponse(.failure(.error(error.localizedDescription))))
                    }
                }
            case let .addCommentResponse(result):
                switch result {
                case .success:
                    return .send(.getComments)
                case let .failure(error):
                    print("Add comment response error: \(error)")
                    return .none
                }
            case .deleteComment(let noticeId, let commentId):
                return .run { [notice = state.notice] send in
                    do {
                        try await kuringLink.deleteComment(noticeId, commentId)
                        await send(.deleteCommentResponse(.success(true)))
                    } catch {
                        await send(.deleteCommentResponse(.failure(.error(error.localizedDescription))))
                    }
                }
            case let .deleteCommentResponse(result):
                switch result {
                case .success:
                    return .send(.getComments)
                case let .failure(error):
                    print("Delete comment response error: \(error)")
                    return .none
                }
            case .reportComment(let commentId, let content):
                return .run { send in
                    do {
                        try await kuringLink.reportComment(commentId, content)
                        await send(.reportCommentResponse(.success(true)))
                    } catch {
                        await send(.reportCommentResponse(.failure(.error(error.localizedDescription))))
                    }
                }
            case let .reportCommentResponse(result):
                switch result {
                case .success:
                    return .send(.getComments)
                case let .failure(error):
                    print("Report comment response error: \(error)")
                    return .none
                }
            case .bookmarkButtonTapped:
                state.isBookmarked.toggle()
                return .none
            case .calendarButtonTapped:
                @Dependency(\.noticeEKEventStore) var noticeEKEventStore
                
                return .run(operation: { [notice = state.notice] send in
                    await noticeEKEventStore.makeEvent(notice)
                    await send(.presentEventView)
                })
            case .delegate:
                return .none
            case .presentEventView:
                state.isPresentedEventView = true
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
