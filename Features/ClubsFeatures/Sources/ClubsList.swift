//
//  ClubsList.swift
//  ClubsFeatures
//
//  Created by Jung Hwan Park on 3/1/26.
//

import Models
import ComposableArchitecture

@Reducer
public struct ClubsListFeature {
    @ObservableState
    public struct State: Equatable {
        public init() { }
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }

    public init() { }
}

