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
        @Presents public var alert: AlertState<Action.Alert>?
        
        public var notice: Notice
        public var comments: CommentData?
        public var isBookmarked: Bool = false
        public var isPresentedEventView: Bool = false
        public var showCommentSection: Bool = false

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
        case toggleCommentSection
        case showNeedsLoginAlert
        /// 댓글 GET~
        case getComments
        case getCommentsResponse(Result<CommentData, CommentsError>)
        /// 댓글 추가
        case addComment(content: String, parentId: Int?)
        case addCommentResponse(Result<Bool, CommentsError>)
        /// 댓글 삭제
        case deleteCommentTapped(noticeId: Int, commentId: Int)
        case deleteCommentResponse(Result<Bool, CommentsError>)
        /// 댓글 신고화면으로 이동
        case pushToReportComment(commentId: Int, content: String)
        
        case bookmarkButtonTapped
        case calendarButtonTapped
        case presentEventView
        
        case binding(BindingAction<State>)

        case delegate(Delegate)
        /// 알림 관련 액션
        case alert(PresentationAction<Alert>)

        public enum Delegate: Equatable {
            case bookmarkUpdated(_ notice: Notice, _ isBookmarked: Bool)
            case pushToReportContent(_ commentId: Int, _ content: String)
            case pushToLogin
        }
        
        /// 알러트
        public enum Alert: Equatable {
            /// 댓글 삭제 진행
            case deleteComment(noticeId: Int, commentId: Int)
            case pushToLogin
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
    @Dependency(\.continuousClock) var clock
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .toggleCommentSection:
                state.showCommentSection.toggle()
                return .none
            case .showNeedsLoginAlert:
                state.alert = AlertState {
                    TextState("로그인이 필요한 서비스에요")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("취소")
                    }
                    
                    ButtonState(
                        role: .destructive,
                        action: .pushToLogin
                    ) {
                        TextState("로그인하기")
                    }
                }
                return .none
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
            case .deleteCommentTapped(let noticeId, let commentId):
                state.alert = AlertState {
                    TextState("해당 단계 후\n댓글이 영구 삭제되어요.")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("취소")
                    }
                    
                    ButtonState(
                        role: .destructive,
                        action: .deleteComment(noticeId: noticeId, commentId: commentId)
                    ) {
                        TextState("삭제하기")
                    }
                }
                return .none
            case let .deleteCommentResponse(result):
                switch result {
                case .success:
                    return .send(.getComments)
                case let .failure(error):
                    print("Delete comment response error: \(error)")
                    return .none
                }
            case .pushToReportComment(let commentId, let content):
                return .concatenate([
                    .send(.toggleCommentSection),
                    .run { _ in
                        try await clock.sleep(for: .milliseconds(200))
                    },
                    .send(.delegate(.pushToReportContent(commentId, content)))
                ])
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
            case let .alert(.presented(alertAction)):
                switch alertAction {
                case .deleteComment(let noticeId, let commentId):
                    return .run { [notice = state.notice] send in
                        do {
                            try await kuringLink.deleteComment(noticeId, commentId)
                            await send(.deleteCommentResponse(.success(true)))
                        } catch {
                            await send(.deleteCommentResponse(.failure(.error(error.localizedDescription))))
                        }
                    }
                case .pushToLogin:
                    return .send(.delegate(.pushToLogin))
                }
            case .presentEventView:
                state.isPresentedEventView = true
                return .none
            default:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .onChange(of: \.isBookmarked) { _, newValue in
            Reduce { state, _ in
                return .send(.delegate(.bookmarkUpdated(state.notice, newValue)))
            }
        }
    }
    
    public init() { }
}
