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
    @AppStorage("com.kuring.sdk.v2.token.accessToken") private var accessToken: String = ""

    public init(store: StoreOf<SubscribedClubsListFeature>) {
        self.store = store
    }
    
    private var isLoggedIn: Bool {
        !accessToken.isEmpty
    }

    public var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                sortByView

                if store.filteredClubs?.clubs.count == 0 {
                    clubsEmptyView
                } else {
                    clubsList
                }
            }
        }
        .navigationTitle("구독")
        .background(Color.Kuring.bg)
        .onAppear { store.send(.onAppear) }
        .alert(store: store.scope(state: \.$alert, action: \.alert))
    }
}

// MARK: - Subviews
private extension SubscribedClubListView {

    var sortByView: some View {
        HStack {
            Spacer()

            HStack(spacing: 9) {
                sortButton(title: "모집 마감일 순", type: .deadline)

                Divider()
                    .frame(width: 1)

                sortButton(title: "가나다 순", type: .alphabetical)
            }
        }
        .frame(height: 32)
        .padding(.horizontal, 20)
    }

    func sortButton(title: String, type: SubscribedClubsListFeature.State.SortType) -> some View {
        let isSelected = store.sortType == type
        return Text(title)
            .font(.system(size: 14))
            .fontWeight(isSelected ? .medium : .regular)
            .foregroundColor(isSelected ? Color.Kuring.caption1 : Color.Kuring.caption2)
            .onTapGesture { store.send(.changeSortBy(by: type)) }
    }

    var clubsList: some View {
        VStack(spacing: 14) {
            ForEach(store.filteredClubs?.clubs ?? [], id: \.id) { club in
                ClubCardView(club: club) {
                    store.send(
                        isLoggedIn
                            ? .subscribeToClub(id: club.id, isSubscribed: club.isSubscribed)
                            : .showNeedsLoginAlert
                    )
                }
                .onTapGesture {
                    store.send(.delegate(.showClubDetail(club)))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    var clubsEmptyView: some View {
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
