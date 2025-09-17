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
            case login(LoginAppFeature.State)
            case findPassword(EmailVerificationFeature.State)
            case changePassword(ChangePasswordFeature.State)
            case signup(EmailVerificationFeature.State)
            case signupTerms
            case setPassword(SetPasswordFeature.State)
            
            case appIconSelector(AppIconSelectorFeature.State)
        }

        public enum Action: Equatable {
            case login(LoginAppFeature.Action)
            case findPassword(EmailVerificationFeature.Action)
            case changePassword(ChangePasswordFeature.Action)
            case signup(EmailVerificationFeature.Action)
            case signupTerms
            case setPassword(SetPasswordFeature.Action)
            
            case appIconSelector(AppIconSelectorFeature.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.login, action: \.login) {
                LoginAppFeature()
            }
            Scope(state: \.changePassword, action: \.changePassword) {
                ChangePasswordFeature()
            }
            Scope(state: \.findPassword, action: \.findPassword) {
                EmailVerificationFeature()
            }
            Scope(state: \.signup, action: \.signup) {
                EmailVerificationFeature()
            }
            Scope(state: \.setPassword, action: \.setPassword) {
                SetPasswordFeature()
            }
            Scope(state: \.appIconSelector, action: \.appIconSelector) {
                AppIconSelectorFeature()
            }
        }

        public init() { }
    }
}
