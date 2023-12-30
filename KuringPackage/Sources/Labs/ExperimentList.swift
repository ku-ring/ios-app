import ComposableArchitecture

@Reducer
public struct ExperimentListFeature {
    @ObservableState
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action: Equatable {
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
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
        }
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
