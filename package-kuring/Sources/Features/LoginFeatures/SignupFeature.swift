//
//  SignupFeature.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/14/25.
//

import Caches
import Foundation
import ComposableArchitecture

@Reducer
public struct SignupFeature {
    @ObservableState
    public struct State: Equatable {
        public var path = StackState<Path.State>()
        
        public init() {}
    }

    public enum Action: BindableAction, Equatable {
        /// 바인딩
        case binding(BindingAction<State>)
        case path(StackAction<Path.State, Path.Action>)
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            return .none
        }
    }

    public init() { }
}

// MARK: - Path
extension SignupFeature {
    @Reducer
    public struct Path {
        @ObservableState
        public enum State: Equatable {
            case setNetPassword(SetPasswordFeature.State)
        }

        public enum Action: Equatable {
            case setNetPassword(SetPasswordFeature.Action)
        }

        public var body: some ReducerOf<Self> {
            
        }
    }
}
