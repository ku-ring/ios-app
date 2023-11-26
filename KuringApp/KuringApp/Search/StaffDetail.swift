//
//  StaffDetail.swift
//  KuringApp
//
//  Created by 이재성 on 11/25/23.
//

import Model
import SwiftUI
import ComposableArchitecture

struct StaffDetailFeature: Reducer {
    struct State: Equatable {
        let staff: Staff
    }
    
    enum Action {
        case emailAddressTapped
        case phoneNumberTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .emailAddressTapped:
                return .none
                
            case .phoneNumberTapped:
                return .none
            }
        }
    }
}

struct StaffDetailView: View {
    let store: StoreOf<StaffDetailFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0.staff }) { viewStore in
            List {
                Text(viewStore.name)
                    .font(.system(size: 20, weight: .bold))
                    .listRowSeparator(.hidden)
                
                Text("\(viewStore.deptName) · \(viewStore.collegeName)")
                    .foregroundStyle(.secondary)
                    .listRowSeparator(.hidden)
                
                Label(viewStore.email, systemImage: "envelope")
                    .listRowSeparator(.hidden)
                
                Label(viewStore.lab, systemImage: "mappin.and.ellipse")
                    .listRowSeparator(.hidden)
                
                Label(viewStore.phone, systemImage: "phone")
                    .listRowSeparator(.hidden)
                
                Label(viewStore.major, systemImage: "book")
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    StaffDetailView(
        store: Store(
            initialState: StaffDetailFeature.State(staff: .random()),
            reducer: { StaffDetailFeature() }
        )
    )
}
