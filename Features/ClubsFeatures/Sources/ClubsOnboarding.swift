//
//  ClubsFeatures.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 03/01/26.
//

import Models
import ComposableArchitecture

@Reducer
public struct ClubsOnboardingFeatures {
    @ObservableState
    public struct State: Equatable {
        public var selectedClubType: ClubsType?
        
        public init() {}
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
    
    public init() {}
}
