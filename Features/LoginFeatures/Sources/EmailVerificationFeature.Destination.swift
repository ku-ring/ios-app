//
//  EmailVerificationFeature.Destination.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/17/25.
//

import ComposableArchitecture

// MARK: - 웹뷰 Destination
extension EmailVerificationFeature {
    @Reducer
    public struct Destination {
        @ObservableState
        public enum State: Equatable {
            case schoolEmail(WebViewFeature.State)
        }

        public enum Action: Equatable {
            case schoolEmail(WebViewFeature.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.schoolEmail, action: \.schoolEmail) {
                WebViewFeature()
            }
        }
        public init() { }
    }
}
