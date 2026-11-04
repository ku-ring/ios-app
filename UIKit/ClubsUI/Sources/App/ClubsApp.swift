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
            case .findPassword:
                if let store = pathStore.scope(state: \.findPassword, action: \.findPassword) {
                    FindPasswordView(store: store)
                        .toolbar(.hidden, for: .tabBar)
                }
            case .changePassword:
                if let store = pathStore.scope(state: \.changePassword, action: \.changePassword) {
                    ChangePasswordView(store: store)
                        .toolbar(.hidden, for: .tabBar)
                }
            case .signup:
                if let store = pathStore.scope(state: \.signup, action: \.signup) {
                    SignupView(store: store)
                        .toolbar(.hidden, for: .tabBar)
                }
            case .signupTerms:
                if let store = pathStore.scope(state: \.signupTerms, action: \.signupTerms) {
                    LoginTermsAndConditionsView(store: store)
                        .toolbar(.hidden, for: .tabBar)
                }
            case .setPassword:
                if let store = pathStore.scope(state: \.setPassword, action: \.setPassword) {
                    SetPasswordView(store: store)
                        .toolbar(.hidden, for: .tabBar)
                }
            case .signupComplete:
                if let store = pathStore.scope(state: \.signupComplete, action: \.signupComplete) {
                    SignupCompleteView(store: store)
                        .toolbar(.hidden, for: .tabBar)
                }
            case .notificationHistory:
                if let store = pathStore.scope(state: \.notificationHistory, action: \.notificationHistory) {
                    NotificationHistoryView(store: store)
                }
            }
        }
    }
}
