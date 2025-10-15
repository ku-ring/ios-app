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
        // MARK: 네비게이션

        /// 루트
        public var bookmarkList = BookmarkListFeature.State()
        /// 스택 네비게이션
        public var path = StackState<Path.State>()
        public var signup = EmailVerificationFeature.State()
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
        /// 이메일 인증 네비게이션
        case signup(EmailVerificationFeature.Action)
        /// 스택 네비게이션 액션 (``BookmarkAppFeature/Path/Action``)
        case path(StackAction<Path.State, Path.Action>)
    }
    
    @Dependency(\.bookmarks) var bookmarks

    public var body: some ReducerOf<Self> {
        Scope(state: \.bookmarkList, action: \.bookmarkList) {
            BookmarkListFeature()
        }
        
        Scope(state: \.signup, action: \.signup) {
            EmailVerificationFeature()
        }

        Reduce { state, action in
            switch action {
            case let .path(.element(id: _, action: .detail(.delegate(action)))):
                switch action {
                case let .bookmarkUpdated(notice, isBookmarked):
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
                case .pushToReportContent(let commentId, let content):
                    state.path.append(
                        Path.State.reportComment(
                            NoticeReportCommentFeature.State(
                                commentId: commentId,
                                content: content
                            )
                        )
                    )
                    return .none
                case .pushToLogin:
                    state.path.append(
                        Path.State.login(
                            LoginAppFeature.State()
                        )
                    )
                    return .none
                }
            case let .path(.element(id: _, action: .reportComment(.delegate(.pop)))):
                state.path.removeLast()
                return .none
            case let .path(.element(id: id, action: .setPassword(.delegate(.pushToSignupComplete)))):
                state.path.append(
                    Path.State.signupComplete(
                        SignupCompleteFeature.State()
                    )
                )
                return .none
            case let .path(.element(id: id, action: .login(.delegate(.popToRoot)))):
                state.path.removeAll()
                return .none
            case let .path(.element(id: id, action: .login(.delegate(.pushToTerms)))):
                state.path.append(
                    Path.State.signupTerms(
                        LoginAppFeature.State()
                    )
                )
                return .none
            case let .path(.element(id: id, action: .login(.delegate(.pushToFindPassword)))):
                state.path.append(
                    Path.State.findPassword(
                        EmailVerificationFeature.State()
                    )
                )
                return .none
            case let .path(.element(id: id, action: .signupTerms(.delegate(.pushToSignup)))):
                state.path.append(
                    Path.State.signup(
                        EmailVerificationFeature.State()
                    )
                )
                return .none
            case let .path(.element(id: id, action: .changePassword(.delegate(.popToRoot)))):
                state.path.removeAll()
                return .none
            case let .path(.element(id: id, action: .signupComplete(.delegate(.popToRoot)))):
                state.path.removeSubrange(1...)
                return .none
            case let .path(.element(id: _, action: .signup(.delegate(.pushToSignupPassword(email))))):
                state.path.append(
                    Path.State.setPassword(
                        SetPasswordFeature.State(email: email)
                    )
                )
                return .none
            case let .path(.element(id: _, action: .findPassword(.delegate(.pushToChangePassword(email))))):
                state.path.append(
                    Path.State.changePassword(
                        SetPasswordFeature.State(email: email)
                    )
                )
                return .none
            case .path, .bookmarkList, .signup:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }

    public init() { }
}
