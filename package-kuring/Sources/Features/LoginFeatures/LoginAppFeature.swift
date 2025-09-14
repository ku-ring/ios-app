//
//  LoginAppFeature.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/14/25.
//

import Caches
import Foundation
import ComposableArchitecture

@Reducer
public struct LoginAppFeature {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }

    public enum Action: Equatable {

    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }

    public init() { }
}
