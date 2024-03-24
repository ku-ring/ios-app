//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import ColorSet
import ComposableArchitecture

@Reducer
public struct ExperimentListFeature {
    @ObservableState
    public struct State: Equatable {
        public init() { }
    }

    public enum Action: Equatable { }

    public var body: some ReducerOf<Self> {
        Reduce { _, _ in
            .none
        }
    }

    public init() { }
}

import SwiftUI

public struct ExperimentList: View {
    @Bindable public var store: StoreOf<ExperimentListFeature>

    public var body: some View {
        List {
            NavigationLink(
                state: LabAppFeature.Path.State.betaA(
                    BetaADetailFeature.State()
                )
            ) {
                Text("베타 A")
            }
            .padding(.vertical, 9)
            .listRowSeparator(.hidden)
            .listRowBackground(ColorSet.bg)
            
            NavigationLink(
                state: LabAppFeature.Path.State.appIcon(
                    AppIconDetailFeature.State()
                )
            ) {
                Text("앱 아이콘 변경하기")
            }
            .padding(.vertical, 9)
            .listRowSeparator(.hidden)
            .listRowBackground(ColorSet.bg)
        }
        .listStyle(.plain)
        .background(ColorSet.bg)
        
    }

    public init(store: StoreOf<ExperimentListFeature>) {
        self.store = store
    }
}

#Preview {
    ExperimentList(
        store: Store(
            initialState: ExperimentListFeature.State(),
            reducer: { ExperimentListFeature() }
        )
    )
}
