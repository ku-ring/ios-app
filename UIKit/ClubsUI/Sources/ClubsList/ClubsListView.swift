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
    
    public init(store: StoreOf<ClubsListFeature>) {
        self.store = store
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
                    .padding(.top, 16)
                }
            }
        }
        .padding(.top, 16)
        .onAppear {
            store.send(.onAppear)
        }
        .sheet(isPresented: $store.showDivisionSelectionSheet) {
            ClubsAffiliationSelectionSheet(
                division: store.clubDivisions.divisions,
                selectedDivisions: $store.selectedCategories
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}

extension ClubsListView {
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
