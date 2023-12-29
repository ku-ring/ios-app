import ComposableArchitecture

@Reducer
public struct LabAppFeature {
    @ObservableState
    public struct State: Equatable {
        /// 스택 기반 네비게이션
        public var path = StackState<Path.State>()
        /// root
        public var betaList = BetaListFeature.State()
        
        public init(
            path: StackState<Path.State> = .init(),
            root: BetaListFeature.State = .init()
        ) {
            self.path = path
            self.betaList = root
        }
    }
    
    public enum Action: Equatable {
        /// root
        case betaList(BetaListFeature.Action)
        /// 스택 기반 네비게이션
        case path(StackAction<Path.State, Path.Action>)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.betaList, action: \.betaList) {
            BetaListFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .betaList:
                return .none
                
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
    
    public init() { }
}

import SwiftUI

public struct LabApp: View {
    @Bindable public var store: StoreOf<LabAppFeature>
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            BetaList(
                store: store.scope(
                    state: \.betaList,
                    action: \.betaList
                )
            )
            .navigationTitle("🧪 쿠링 실험실")
        } destination: { store in
            switch store.state {
            case .betaA:
                if let store = store.scope(state: \.betaA, action: \.betaA) {
                    BetaADetailView(store: store)
                }
            }
        }

    }
    
    public init(store: StoreOf<LabAppFeature>) {
        self.store = store
    }
}

#Preview {
    LabApp(
        store: Store(
            initialState: LabAppFeature.State(),
            reducer: { LabAppFeature() }
        )
    )
}
