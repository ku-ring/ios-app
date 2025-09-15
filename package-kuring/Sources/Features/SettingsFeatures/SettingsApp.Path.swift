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
            case findPassword(FindPasswordFeature.State)
            case changePassword(ChangePasswordFeature.State)
            case signup(SignupFeature.State)
            case setPassword(SetPasswordFeature.State)
            
            case appIconSelector(AppIconSelectorFeature.State)
        }

        public enum Action: Equatable {
            case login(LoginAppFeature.Action)
            case findPassword(FindPasswordFeature.Action)
            case changePassword(ChangePasswordFeature.Action)
            case signup(SignupFeature.Action)
            case setPassword(SetPasswordFeature.Action)
            
            case appIconSelector(AppIconSelectorFeature.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.login, action: \.login) {
                LoginAppFeature()
            }
            Scope(state: \.findPassword, action: \.findPassword) {
                FindPasswordFeature()
            }
            Scope(state: \.changePassword, action: \.changePassword) {
                ChangePasswordFeature()
            }
            Scope(state: \.signup, action: \.signup) {
                SignupFeature()
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
