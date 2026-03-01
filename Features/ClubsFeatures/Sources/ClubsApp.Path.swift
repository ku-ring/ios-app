//
//  ClubsApp.Path.swift
//  ClubsFeatures
//
//  Created by Jung Hwan Park on 3/1/26.
//

import Models
import ComposableArchitecture

extension ClubsAppFeature {
    @Reducer
    public struct Path {
        @ObservableState
        public enum State: Equatable {
            case clubsList(ClubsListFeature.State)
        }
        
        public enum Action: Equatable {
            case clubsList(ClubsListFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.clubsList, action: \.clubsList) {
                ClubsListFeature()
            }
        }
    }
}
