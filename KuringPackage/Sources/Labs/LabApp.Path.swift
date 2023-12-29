import ComposableArchitecture

extension LabAppFeature {
    @Reducer
    public struct Path {
        @ObservableState
        public enum State: Equatable {
            case betaA(BetaADetailFeature.State)
        }
        
        public enum Action: Equatable {
            case betaA(BetaADetailFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.betaA, action: \.betaA) {
                BetaADetailFeature()
            }
        }
        
        public init() { }
    }
}
