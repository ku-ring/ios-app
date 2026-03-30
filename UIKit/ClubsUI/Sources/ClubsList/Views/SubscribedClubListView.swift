//
//  SubscribedClubListView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 3/4/26.
//

import Models
import SwiftUI
import ClubsFeatures
import ComposableArchitecture

public struct SubscribedClubListView: View {
    @Bindable var store: StoreOf<ClubsListFeature>
    @AppStorage("com.kuring.sdk.v2.token.accessToken") private var accessToken: String = ""
    
    public init(store: StoreOf<ClubsListFeature>) {
        self.store = store
    }
    
    private var isLoggedIn: Bool {
        !accessToken.isEmpty
    }
    
    private var sortedList: [Club] {
        var clubs = store.originalClubs
        switch store.subscribedClubsSortType {
        case .deadline:
            clubs?.clubs.sort {
                parseDate($0.recruitEndDate ?? "") ?? .distantFuture <
                    parseDate($1.recruitEndDate ?? "") ?? .distantFuture
            }
        case .alphabetical:
            clubs?.clubs.sort { $0.name < $1.name }
        }
        
        return clubs?.clubs ?? []
    }
    
    private var subscribedList: [Club] {
        sortedList.filter { $0.isSubscribed }
    }
    
    private func parseDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-ddTHH:mm:ss"
        return formatter.date(from: string)
    }
    
    public var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                sortByView

                if subscribedList.isEmpty {
                    clubsEmptyView
                } else {
                    clubsList
                }
            }
        }
        .navigationTitle("구독")
        .background(Color.Kuring.bg)
        .alert(store: store.scope(state: \.$subscribedAlert, action: \.subscribedAlert))
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

    func sortButton(title: String, type: ClubsListFeature.State.SortType) -> some View {
        let isSelected = store.subscribedClubsSortType == type
        return Text(title)
            .font(.system(size: 14))
            .fontWeight(isSelected ? .medium : .regular)
            .foregroundColor(isSelected ? Color.Kuring.caption1 : Color.Kuring.caption2)
            .onTapGesture {
                store.send(.changeSubscribedClubSortBy(by: type))
            }
    }

    var clubsList: some View {
        VStack(spacing: 14) {
            ForEach(subscribedList, id: \.id) { club in
                ClubCardView(club: club) {
                    store.send(
                        isLoggedIn
                            ? .subscribeToClub(id: club.id, isSubscribed: club.isSubscribed)
                            : .showSubscribedNeedsLoginAlert
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

            Text("구독된 동아리가 없어요!")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
        }
        .padding(.top, 120)
    }
}
