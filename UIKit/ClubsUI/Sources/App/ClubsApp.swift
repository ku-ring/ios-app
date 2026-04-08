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
            ClubsContentView(store: store)
                .navigationTitle("동아리")
                .navigationBarTitleDisplayMode(.inline)
                .fullScreenCover(isPresented: $store.needsOnboarding) {
                    ClubsOnboardingView(store: store)
                }
        } destination: { [store] pathStore in
            switch pathStore.state {
            case .detail:
                if let store = pathStore.scope(state: \.detail, action: \.detail) {
                    ClubInfoDetailView(store: store)
                }
            case .subscribedClubsList:
                SubscribedClubListView(
                    store: store.scope(state: \.clubsList, action: \.clubsList)
                )
            case .login:
                if let store = pathStore.scope(state: \.login, action: \.login) {
                    LoginView(store: store)
                }
            case .notificationHistory:
                if let store = pathStore.scope(state: \.notificationHistory, action: \.notificationHistory) {
                    NotificationHistoryView(store: store)
                }
            }
        }
    }
}
