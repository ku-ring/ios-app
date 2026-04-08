//
//  ClubsApp.Path.swift
//  ClubsFeatures
//
//  Created by Jung Hwan Park on 3/1/26.
//

import Models
import LoginFeatures
import ComposableArchitecture

extension ClubsAppFeature {
    @Reducer
    public struct Path {
        @ObservableState
        public enum State: Equatable {
            case detail(ClubsDetailFeature.State)
            case subscribedClubsList
            /// 로그인
            case login(LoginAppFeature.State)
            case notificationHistory(NotificationHistoryFeature.State)
        }
        
        public enum Action: Equatable {
            case detail(ClubsDetailFeature.Action)
            case subscribedClubsList(ClubsListFeature.Action)
            /// 로그인
            case login(LoginAppFeature.Action)
            case notificationHistory(NotificationHistoryFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.detail, action: \.detail) {
                ClubsDetailFeature()
            }
            Scope(state: \.login, action: \.login) {
                LoginAppFeature()
            }
            Scope(state: \.notificationHistory, action: \.notificationHistory) {
                NotificationHistoryFeature()
            }
        }
    }
}
