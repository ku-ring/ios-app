//  ClubsUI.swift
//  This file can be safely deleted or expanded.
//
//  Created by Tuist™️
//

import SwiftUI
import LoginUI
import ClubsFeatures
import ComposableArchitecture

public struct ClubsApp: View {
    @Bindable var store: StoreOf<ClubsAppFeature>
    
    public init(store: StoreOf<ClubsAppFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            Group {
                if !store.didFinishOnboarding {
                    ClubsOnboardingView(store: store)
                        .transition(.move(edge: .leading))
                } else {
                    ClubsContentView(store: store)
                }
            }
        } destination: { store in
            switch store.state {
            case .detail:
                if let store = store.scope(
                    state: \.detail,
                    action: \.detail
                ) {
                    ClubInfoDetailView(store: store)
                }
            case .subscribedClubsList:
                if let store = store.scope(
                    state: \.subscribedClubsList,
                    action: \.subscribedClubsList
                ) {
                    SubscribedClubListView(store: store)
                }
            case .login:
                if let store = store.scope(
                    state: \.login,
                    action: \.login
                ) {
                    LoginView(store: store)
                }
            case .notificationHistory:
                if let store = store.scope(
                    state: \.notificationHistory,
                    action: \.notificationHistory
                ) {
                    NotificationHistoryView(store: store)
                }
            }
        }
    }
}
