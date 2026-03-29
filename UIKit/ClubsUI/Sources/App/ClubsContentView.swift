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
    @AppStorage("hasShownClubsOnboarding") private var hasShownClubsOnboarding: Bool = false
    @AppStorage("hasShownClubsIntroSnackbar") private var hasShownSnackbar: Bool = false
    
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
            if hasShownClubsOnboarding {
                ClubsIntroSnackbar()
                    .padding(.bottom, 11)
                    .opacity(hasShownSnackbar ? 0.0 : 1.0)
                    .onAppear {
                        Task {
                            try await Task.sleep(for: .seconds(5))
                            withAnimation {
                                hasShownSnackbar = true
                            }
                        }
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    store.send(.pushToSubscribedClubsList)
                } label: {
                    Image("star", bundle: .module)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.Kuring.gray400)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    store.send(.pushToNotificationHistory)
                } label: {
                    Image("bell", bundle: .module)
                        .renderingMode(.template)
                        .foregroundStyle(Color.Kuring.gray400)
                }
            }
        }
        .onAppear {
            guard !hasShownClubsOnboarding else {
                return
            }
            
            Task {
                try await Task.sleep(for: .seconds(0.6))
                
                if !store.needsOnboarding {
                    withAnimation(.easeOut(duration: 0.4)) {
                        store.needsOnboarding = true
                    }
                }
            }
        }
    }
}

#Preview {
    ClubsContentView(store: .init(initialState: ClubsAppFeature.State()) {
        ClubsAppFeature()
    })
}
