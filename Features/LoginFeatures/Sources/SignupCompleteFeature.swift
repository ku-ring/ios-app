//
//  SignupCompleteFeature.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/17/25.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct SignupCompleteFeature {
    @ObservableState
    public struct State: Equatable {

        public init() {}
    }

    public enum Action: Equatable {
        case popToRoot
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case popToRoot
        }
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .popToRoot:
                return .send(.delegate(.popToRoot))
            case .delegate:
                return .none
            }
        }
    }

    public init() {}
}

