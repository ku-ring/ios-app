import Models
import LoginUI
import SwiftUI
import ClubsUI
import Networks
import ColorSet
import ClubsFeatures
import ComposableArchitecture

@main
struct ClubsApp: App {
    @State var store: StoreOf<ClubsAppFeature> = .init(initialState: ClubsAppFeature.State()) {
        ClubsAppFeature()._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                ClubsContentView(store: store)
                    .fullScreenCover(isPresented: $store.needsOnboarding) {
                        ClubsOnboardingView(store: store)
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
}
