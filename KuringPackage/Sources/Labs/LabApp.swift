import ComposableArchitecture

@Reducer
public struct LabAppFeature {
    @ObservableState
    public struct State: Equatable {
        /// 스택 기반 네비게이션
        public var path = StackState<Path.State>()
        /// root
        public var betaList = ExperimentListFeature.State()
        
        public init(
            path: StackState<Path.State> = .init(),
            root: ExperimentListFeature.State = .init()
        ) {
            self.path = path
            self.betaList = root
        }
    }
    
    public enum Action: Equatable {
        /// root
        case betaList(ExperimentListFeature.Action)
        /// 스택 기반 네비게이션
        case path(StackAction<Path.State, Path.Action>)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.betaList, action: \.betaList) {
            ExperimentListFeature()
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
            ExperimentList(
                store: store.scope(
                    state: \.betaList,
                    action: \.betaList
                )
            )
            .navigationTitle("🧪 쿠링 실험실")
        } destination: { store in
            switch store.state {
            /// - Important: 테스트를 위한 케이스 이므로 삭제하지 말 것
            case .betaA:
                if let store = store.scope(state: \.betaA, action: \.betaA) {
                    BetaADetailView(store: store)
                }
            case .appIcon:
                if let store = store.scope(state: \.appIcon, action: \.appIcon) {
                    AppIconDetailView(store: store)
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
