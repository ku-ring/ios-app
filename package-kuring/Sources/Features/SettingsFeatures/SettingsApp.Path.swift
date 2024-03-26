//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import ComposableArchitecture

extension SettingsAppFeature {
    @Reducer
    public struct Path {
        @ObservableState
        public enum State: Equatable {
            case appIconSelector(AppIconSelectorFeature.State)
        }

        public enum Action: Equatable {
            case appIconSelector(AppIconSelectorFeature.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.appIconSelector, action: \.appIconSelector) {
                AppIconSelectorFeature()
            }
        }

        public init() { }
    }
}
