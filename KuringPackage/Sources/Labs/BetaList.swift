import ComposableArchitecture

@Reducer
public struct BetaListFeature {
    @ObservableState
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action: Equatable {
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case showBetaA
        }
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none
            }
        }
    }
    
    public init() { }
}

import SwiftUI

public struct BetaList: View {
    @Bindable public var store: StoreOf<BetaListFeature>
    
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
    
    public init(store: StoreOf<BetaListFeature>) {
        self.store = store
    }
}

#Preview {
    BetaList(
        store: Store(
            initialState: BetaListFeature.State(),
            reducer: { BetaListFeature() }
        )
    )
}
