//
//  FindPasswordFeature.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/14/25.
//

import Caches
import Foundation
import ComposableArchitecture

@Reducer
public struct FindPasswordFeature {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }

    public enum Action: BindableAction, Equatable {
        /// 바인딩
        case binding(BindingAction<State>)
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            return .none
        }
    }

    public init() { }
}
