import NoticeFeatures
import ComposableArchitecture

extension BookmarkAppFeature {
    @Reducer
    public struct Path {
        @ObservableState // TODO: 필요??
        public enum State: Equatable {
            case detail(NoticeDetailFeature.State)
        }
        
        public enum Action {
            case detail(NoticeDetailFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.detail, action: \.detail) {
                NoticeDetailFeature()
            }
        }
    }
}
