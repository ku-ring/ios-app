//
//  ClubsListView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 3/1/26.
//

import SwiftUI
import ClubsFeatures
import ComposableArchitecture

struct ClubsListView: View {
    @Bindable var store: StoreOf<ClubsListFeature>
    @AppStorage("com.kuring.sdk.v2.token.accessToken") private var accessToken: String = ""

    public init(store: StoreOf<ClubsListFeature>) {
        self.store = store
    }

    private var isLoggedIn: Bool {
        !accessToken.isEmpty
    }

    var body: some View {
        ClubsCategoryPicker(selection: $store.selectedClubType)
            .padding(.horizontal, 20)

        Divider()
            .frame(height: 0.25)

        ClubsTagSelector(store: store)
            .padding(.horizontal, 20)

        ScrollView(.vertical) {
            VStack(spacing: 0) {
                sortByView

                if (store.filteredClubs?.clubs.count ?? 0) == 0 {
                    clubsEmptyView
                } else {
                    clubsList
                }
            }
            .padding(.bottom, 20)
        }
        .refreshable {
            store.send(.getClubsList)
        }
        .padding(.top, 8)
        .onAppear {
            store.send(.onAppear)
        }
        .sheet(isPresented: $store.showDivisionSelectionSheet, onDismiss: {
            store.send(.applyFiltersAndSort)
        }, content: {
            ClubsAffiliationSelectionSheet(
                division: store.clubDivisions.divisions,
                selectedDivisions: $store.selectedDivisions
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        })
        .alert(store: store.scope(state: \.$alert, action: \.alert))
    }
}

// MARK: - Sub-views

private extension ClubsListView {

    var sortByView: some View {
        HStack {
            Text("총 \(store.filteredClubs?.clubs.count ?? 0)개")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.Kuring.caption1)

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
        .padding(.top, 12)
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
