//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import LoginFeatures
import NoticeFeatures
import ComposableArchitecture

extension BookmarkAppFeature {
    @Reducer
    public struct Path {
        @ObservableState // TODO: 필요??
        public enum State: Equatable {
            case detail(NoticeDetailFeature.State)
            case reportComment(NoticeReportCommentFeature.State)
            
            /// 로그인
            case login(LoginAppFeature.State)
            /// 비밀번호 찾기
            case findPassword(EmailVerificationFeature.State)
            case changePassword(SetPasswordFeature.State)
            /// 회원가입
            case signup(EmailVerificationFeature.State)
            case signupTerms(LoginAppFeature.State)
            case setPassword(SetPasswordFeature.State)
            case signupComplete(SignupCompleteFeature.State)
        }

        public enum Action {
            case detail(NoticeDetailFeature.Action)
            case reportComment(NoticeReportCommentFeature.Action)
            
            /// 로그인
            case login(LoginAppFeature.Action)
            /// 비밀번호 찾기
            case findPassword(EmailVerificationFeature.Action)
            case changePassword(SetPasswordFeature.Action)
            /// 회원가입
            case signup(EmailVerificationFeature.Action)
            case signupTerms(LoginAppFeature.Action)
            case setPassword(SetPasswordFeature.Action)
            case signupComplete(SignupCompleteFeature.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.detail, action: \.detail) {
                NoticeDetailFeature()
            }
            Scope(state: \.reportComment, action: \.reportComment) {
                NoticeReportCommentFeature()
            }
            
            Scope(state: \.login, action: \.login) {
                LoginAppFeature()
            }
            Scope(state: \.changePassword, action: \.changePassword) {
                SetPasswordFeature()
            }
            Scope(state: \.findPassword, action: \.findPassword) {
                EmailVerificationFeature()
            }
            Scope(state: \.signup, action: \.signup) {
                EmailVerificationFeature()
            }
            Scope(state: \.signupTerms, action: \.signupTerms) {
                LoginAppFeature()
            }
            Scope(state: \.setPassword, action: \.setPassword) {
                SetPasswordFeature()
            }
            Scope(state: \.signupComplete, action: \.signupComplete) {
                SignupCompleteFeature()
            }
        }
    }
}
