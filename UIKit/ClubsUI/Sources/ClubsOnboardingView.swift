//
//  ClubsOnboardingView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 1/31/26.
//

import Models
import SwiftUI
import CommonUI
import ClubsFeatures
import ComposableArchitecture

public struct ClubsOnboardingView: View {
    @Bindable var store: StoreOf<ClubsAppFeature>
    @AppStorage("hasShownClubsOnboarding") private var hasShownClubsOnboarding: Bool = false
    
    public init(store: StoreOf<ClubsAppFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            HeaderView(
                title: "어떤 동아리를 찾고 있나요?",
                subtitle: "관심있는 카테고리의 동아리를 탐색해보아요"
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 16) {
                clubsOnboardingCard(types: [.academic, .culture_art, .social_value, .activity])
            }
            .padding(.top, 32)
            
            Spacer()
            
            ActionButton(
                title: "확인",
                isActive: .init(get: {
                    store.clubsList.selectedClubType != .all
                }, set: { _ in })
            ) {
                withAnimation(.easeOut(duration: 0.4)) {
                    store.needsOnboarding = false
                    hasShownClubsOnboarding = true
                }
            }
            .padding(.top, 16)
            
            Text("건너뛰기")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
                .padding(.top, 20)
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.4)) {
                        store.clubsList.selectedClubType = .all
                        store.needsOnboarding = false
                        hasShownClubsOnboarding = true
                    }
                }
        }
        .padding(28)
        .ignoresSafeArea(.keyboard)
        .background(Color.Kuring.bg)
    }
    
    @ViewBuilder
    private func clubsOnboardingCard(types: [ClubsType]) -> some View {
        ForEach(types, id: \.rawValue) { type in
            HStack(alignment: .center) {
                Image(type.imageName, bundle: .module)
                    .frame(width: 50, height: 50)
                
                VStack(spacing: 6) {
                    Text(type.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.Kuring.body)
                    
                    Text(type.subtitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.Kuring.caption1)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(store.clubsList.selectedClubType == type ? Color.Kuring.primarySelected : Color.Kuring.bg)
                    .stroke(store.clubsList.selectedClubType == type ? Color.Kuring.primary : Color.Kuring.gray200, lineWidth: 1)
            )
            .frame(maxWidth: .infinity)
            .onTapGesture {
                store.clubsList.selectedClubType = store.clubsList.selectedClubType == type ? .all : type
            }
        }
    }
}
