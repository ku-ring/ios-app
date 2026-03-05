//
//  ClubsApp.swift
//  ClubsFeatures
//
//  Created by Jung Hwan Park on 3/1/26.
//

import Models
import LoginFeatures
import ComposableArchitecture

@Reducer
public struct ClubsAppFeature {
    @ObservableState
    public struct State: Equatable {
        /// 루트
        public var clubsList = ClubsListFeature.State()
        /// 네비게이션
        public var path = StackState<Path.State>()
        
        public var didFinishOnboarding: Bool = false
        
        public init(
            path: StackState<Path.State> = StackState<Path.State>()
        ) {
            self.path = path
        }
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        /// 루트(``ClubsOnboardingFeatures``) 액션
        case clubsList(ClubsListFeature.Action)
        /// 스택 네비게이션 액션 (``ClubsAppFeature/Path``)
        case path(StackAction<Path.State, Path.Action>)
        case pushToSubscribedClubsList
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.clubsList, action: \.clubsList) {
            ClubsListFeature()
        }
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case let .clubsList(.delegate(delegate)):
                switch delegate {
                case .showClubDetail(let club):
                    state.path.append(
                        Path.State.detail(
                            ClubsDetailFeature.State(club: club)
                        )
                    )
                    return .none
                case .pushToLogin:
                    state.path.append(
                        Path.State.login(
                            LoginAppFeature.State()
                        )
                    )
                    return .none
                }
            case .path(.element(id: _, action: .subscribedClubsList(.delegate(.showClubDetail(let club))))):
                state.path.append(
                    Path.State.detail(
                        ClubsDetailFeature.State(club: club)
                    )
                )
                return .none
            case .path(.element(id: _, action: .subscribedClubsList(.delegate(.pushToLogin)))),
                    .path(.element(id: _, action: .detail(.delegate(.pushToLogin)))):
                state.path.append(
                    Path.State.login(
                        LoginAppFeature.State()
                    )
                )
                return .none
            case .path(.element(id: _, action: .login(.delegate(.popToRoot)))):
                state.path.removeAll()
                return .none
            case .pushToSubscribedClubsList:
                state.path.append(
                    Path.State.subscribedClubsList(SubscribedClubsListFeature.State())
                )
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
    
    public init() {}
}

