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
    
    @Bindable var store: StoreOf<ClubsOnboardingFeatures>
    
    public init(store: StoreOf<ClubsOnboardingFeatures>) {
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
                clubsOnboardingCard(types: ClubsType.allCases)
            }
            .padding(.top, 32)
            
            Spacer()
            
            ActionButton(
                title: "확인",
                isActive: .init(get: {
                    store.selectedClubType != nil
                }, set: { _ in })
            ) {
                
            }
            .padding(.top, 16)
            
            Text("건너뛰기")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
                .padding(.top, 20)
        }
        .padding(20)
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
                    .fill(store.selectedClubType == type ? Color.Kuring.primarySelected : Color.Kuring.bg)
                    .stroke(store.selectedClubType == type ? Color.Kuring.primary : Color.Kuring.gray200, lineWidth: 1)
            )
            .frame(maxWidth: .infinity)
            .onTapGesture {
                store.selectedClubType = store.selectedClubType == type ? nil : type
            }
        }
    }
}


#Preview {
    ClubsOnboardingView(store: .init(initialState: ClubsOnboardingFeatures.State(), reducer: {
        ClubsOnboardingFeatures()
    }))
}
