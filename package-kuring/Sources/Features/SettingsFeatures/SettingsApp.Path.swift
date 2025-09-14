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
            case appIconSelector(AppIconSelectorFeature.State)
        }

        public enum Action: Equatable {
            case login(LoginAppFeature.Action)
            case appIconSelector(AppIconSelectorFeature.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.login, action: \.login) {
                LoginAppFeature()
            }
            Scope(state: \.appIconSelector, action: \.appIconSelector) {
                AppIconSelectorFeature()
            }
        }

        public init() { }
    }
}
