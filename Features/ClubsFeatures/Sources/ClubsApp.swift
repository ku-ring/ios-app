//
//  ClubsApp.swift
//  ClubsFeatures
//
//  Created by Jung Hwan Park on 3/1/26.
//

import Models
import ComposableArchitecture

@Reducer
public struct ClubsAppFeature {
    @ObservableState
    public struct State: Equatable {
        /// 네비게이션
        public var path = StackState<Path.State>()
        
        public init(
            path: StackState<Path.State> = StackState<Path.State>()
        ) {
            self.path = path
        }
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        /// 스택 네비게이션 액션 (``ClubsAppFeature/Path``)
        case path(StackAction<Path.State, Path.Action>)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}

