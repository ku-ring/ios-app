//
//  SubscribedClubListView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 3/4/26.
//

import SwiftUI
import ClubsFeatures
import ComposableArchitecture

public struct SubscribedClubListView: View {
    @Bindable var store: StoreOf<SubscribedClubsListFeature>
    
    public init(store: StoreOf<SubscribedClubsListFeature>) {
        self.store = store
    }

    public var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                sortByView
                
                if store.filteredClubs?.clubs.count == 0 {
                    clubsEmptyView
                } else {
                    VStack(spacing: 14) {
                        ForEach(store.filteredClubs?.clubs ?? [], id: \.id) { club in
                            ClubCardView(club: club) {
                                store.send(.subscribeToClub(id: club.id, isSubscribed: club.isSubscribed))
                            }
                            .onTapGesture {
                                store.send(.delegate(.showClubDetail(club)))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
            }
        }
        .navigationTitle("구독")
        .onAppear {
            store.send(.onAppear)
        }
    }
}

extension SubscribedClubListView {
    private var sortByView: some View {
        HStack {
            Spacer()

            HStack(spacing: 9) {
                Text("모집 마감일 순")
                    .font(.system(size: 14))
                    .fontWeight(store.sortType == .deadline ? .medium : .regular)
                    .foregroundColor(
                        store.sortType == .deadline
                        ? Color.Kuring.caption1
                        : Color.Kuring.caption2
                    )
                    .onTapGesture {
                        store.send(.changeSortBy(by: .deadline))
                    }

                Divider()
                    .frame(width: 1)

                Text("가나다 순")
                    .font(.system(size: 14))
                    .fontWeight(store.sortType == .alphabetical ? .medium : .regular)
                    .foregroundColor(
                        store.sortType == .alphabetical
                        ? Color.Kuring.caption1
                        : Color.Kuring.caption2
                    )
                    .onTapGesture {
                        store.send(.changeSortBy(by: .alphabetical))
                    }
            }
        }
        .frame(height: 32)
        .padding(.horizontal, 20)

    }
    
    private var clubsEmptyView: some View {
        VStack(alignment: .center, spacing: 16) {
            Image("alert-circle", bundle: .module)
                .resizable()
                .frame(width: 57, height: 57)
            
            Text("등록된 동아리가 없어요!")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
        }
        .padding(.top, 120)
    }
}
