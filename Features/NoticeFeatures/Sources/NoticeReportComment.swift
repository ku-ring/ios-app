//
//  NoticeReportComment.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/6/25.
//

import Caches
import Models
import SwiftUI
import ComposableArchitecture

@Reducer
public struct NoticeReportCommentFeature {
    @ObservableState
    public struct State: Equatable {
        public var commentId: Int
        public var content: String
        @Presents public var alert: AlertState<Action.Alert>?
        
        public init(commentId: Int, content: String) {
            self.commentId = commentId
            self.content = content
        }
    }
    
    public enum Action: Equatable {
        /// 댓글 신고
        case reportComment(_ content: String)
        case reportCommentResponse(Result<Bool, CommentsError>)
        case delegate(Delegate)
        case alert(PresentationAction<Alert>)
        
        /// 신고 완료시 뒤로가기 위함
        public enum Delegate {
            case pop
        }
        
        /// 알러트
        public enum Alert: Equatable { }
        
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
        Reduce { state, action in
            switch action {
            case .reportComment(let content):
                return .run { [commentId = state.commentId] send in
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
                    return .send(.delegate(.pop))
                case let .failure(error):
                    state.alert = AlertState {
                        TextState("댓글 신고에 실패했어요.")
                    }
                    return .none
                }
            case .delegate:
                return .none
            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
    
    public init() { }
}
