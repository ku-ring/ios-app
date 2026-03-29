//
//  ClubsTagSelector.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/8/26.
//

import Models
import SwiftUI
import ColorSet
import ClubsFeatures
import ComposableArchitecture

public struct ClubsTagSelector: View {
    @Bindable var store: StoreOf<ClubsListFeature>
    
    public init(store: StoreOf<ClubsListFeature>) {
        self.store = store
    }
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                // 초기화 버튼 (선택된 게 있을 때만)
                if !store.selectedDivisions.isEmpty {
                    Button {
                        store.selectedDivisions.removeAll()
                        store.send(.applyFiltersAndSort)
                    } label: {
                        Image("refresh-cw", bundle: .module)
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.Kuring.gray400)
                            .padding(.vertical, 6.5)
                            .padding(.horizontal, 14)
                            .background(
                                Capsule()
                                    .fill(Color.Kuring.bg)
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(
                                              Color.Kuring.gray200,
                                              lineWidth: 1
                                            )
                                    )
                            )
                    }
                }

                ForEach(store.clubDivisions.divisions, id: \.self) { division in
                    ClubsTag(
                        division: division,
                        isSelected: store.selectedDivisions.contains(division)
                    ) {
                        toggle(division)
                        store.send(.applyFiltersAndSort)
                    }
                }
                .frame(height: 37)
            }
            .padding(.trailing, 37)
        }
        .overlay(alignment: .trailing) {
            LinearGradient(
                colors: [Color.Kuring.bg, Color.clear],
                startPoint: .center,
                endPoint: .leading
            )
            .frame(width: 59, height: 37, alignment: .trailing)
            .overlay(alignment: .trailing) {
                Button {
                    store.showDivisionSelectionSheet = true
                } label: {
                    Image(systemName: "chevron.down")
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.Kuring.gray300)
                }
            }
        }
        .padding(.top, 16)
    }

    // Use Transaction to disable all animation
    private func toggle(_ division: Division) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            if store.selectedDivisions.contains(division) {
                store.selectedDivisions.remove(division)
            } else {
                store.selectedDivisions.insert(division)
            }
        }
    }
}

#Preview {
    ClubsTagSelector(store: .init(initialState: ClubsListFeature.State(), reducer: {
        ClubsListFeature()
    }))
}
