import ComposableArchitecture

extension LabAppFeature {
    @Reducer
    public struct Path {
        @ObservableState
        public enum State: Equatable {
            /// - Important: 테스트를 위한 케이스 이므로 삭제하지 말 것
            case betaA(BetaADetailFeature.State)
            case appIcon(AppIconDetailFeature.State)
        }
        
        public enum Action: Equatable {
            /// - Important: 테스트를 위한 케이스 이므로 삭제하지 말 것
            case betaA(BetaADetailFeature.Action)
            case appIcon(AppIconDetailFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
            /// - Important: 테스트를 위한 리듀서 이므로 삭제하지 말 것
            Scope(state: \.betaA, action: \.betaA) {
                BetaADetailFeature()
            }
            
            Scope(state: \.appIcon, action: \.appIcon) {
                AppIconDetailFeature()
            }
        }
        
        public init() { }
    }
}
