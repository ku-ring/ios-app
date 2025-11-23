//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import LoginFeatures
import ComposableArchitecture

extension SettingsAppFeature {
    @Reducer
    public struct Path {
        @ObservableState
        public enum State: Equatable {
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
            /// 회원 탈퇴
            case deleteAccount(DeleteAccountFeature.State)
            case deleteAccountComplete(DeleteAccountFeature.State)
            
            case appIconSelector(AppIconSelectorFeature.State)
        }

        public enum Action: Equatable {
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
            /// 회원 탈퇴
            case deleteAccount(DeleteAccountFeature.Action)
            case deleteAccountComplete(DeleteAccountFeature.Action)
            
            case appIconSelector(AppIconSelectorFeature.Action)
        }

        public var body: some ReducerOf<Self> {
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
            Scope(state: \.deleteAccount, action: \.deleteAccount) {
                DeleteAccountFeature()
            }
            Scope(state: \.deleteAccountComplete, action: \.deleteAccountComplete) {
                DeleteAccountFeature()
            }
            Scope(state: \.appIconSelector, action: \.appIconSelector) {
                AppIconSelectorFeature()
            }
        }

        public init() { }
    }
}
