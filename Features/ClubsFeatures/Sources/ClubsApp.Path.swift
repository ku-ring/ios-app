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
            case detail(ClubsDetailFeature.State)
        }
        
        public enum Action: Equatable {
            case detail(ClubsDetailFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.detail, action: \.detail) {
                ClubsDetailFeature()
            }
        }
    }
}
