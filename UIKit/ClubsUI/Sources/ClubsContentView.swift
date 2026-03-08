//
//  ClubsContentView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/8/26.
//

import SwiftUI
import ColorSet
import ClubsFeatures
import ComposableArchitecture

public struct ClubsContentView: View {
    @Bindable var store: StoreOf<ClubsAppFeature>
    @AppStorage("hasShownClubsIntroSnackbar") private var hasShownSnackbar: Bool = false
    
    let isClubEmpty = false
    
    public init(store: StoreOf<ClubsAppFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ClubsListView(
                store: store.scope(
                    state: \.clubsList,
                    action: \.clubsList
                )
            )
        }
        .frame(maxWidth: .infinity)
        .background(Color.Kuring.bg)
        .overlay(alignment: .bottom) {
            ClubsIntroSnackbar()
                .opacity(hasShownSnackbar ? 0.0 : 1.0)
                .onAppear {
                    Task {
                        try await Task.sleep(for: .seconds(3))
                        withAnimation {
                            hasShownSnackbar = true
                        }
                    }
                }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    Image("star", bundle: .module)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .onTapGesture {
                            store.send(.pushToSubscribedClubsList)
                        }
                    
                    Image("bell", bundle: .module)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .onTapGesture {
                            store.send(.pushToNotificationHistory)
                        }
                }
                .padding(.horizontal, 6)
            }
        }
    }
}

#Preview {
    ClubsContentView(store: .init(initialState: ClubsAppFeature.State()) {
        ClubsAppFeature()
    })
}
