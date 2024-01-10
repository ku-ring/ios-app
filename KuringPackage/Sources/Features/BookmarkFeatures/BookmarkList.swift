import Caches
import Models
import ComposableArchitecture

/// ```swift
/// @Bindable var store = Store(initialState: BookmarkListFeature.State())
/// ```
@Reducer
public struct BookmarkListFeature: Reducer {
    @ObservableState
    public struct State: Equatable {
        public var bookmarkedNotices: IdentifiedArrayOf<Notice> = []
        
        /// 편집시 선택한 북마크 ID
        /// - Note: 순서는 중요하지 않고 중복제거만 중요하므로 `Set` 사용
        public var selectedIDs: Set<Notice.ID> = []
        
        public var editMode: EditMode = .none
        
        public enum EditMode: Equatable {
            case `none`
            case editing(deletable: Bool)
        }
        
        public init(bookmarkedNotices: [Notice] = []) {
            self.bookmarkedNotices = IdentifiedArray(uniqueElements: bookmarkedNotices)
        }
    }
    
    public enum Action: Equatable, BindableAction {
        /// 바인딩
        case binding(BindingAction<State>)
        /// 뷰가 나타날 때 가장 첫번째로 수행해야 하는 비동기 액션
        case onTask
        /// 북마크 리스트가 업데이트 되면 호출되는 액션
        case bookmarksUpdate([Notice])
        /// 편집 버튼 눌렀을 때
        case editButtonTapped
        /// 전체 선택 버튼 눌렀을 때
        case selectAllButtonTapped
        /// 삭제 버튼 눌렀을 때
        case deleteButtonTapped
    }
    
    /// 북마크 저장소 디펜던시
    @Dependency(\.bookmarks) public var bookmarks
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.selectedIDs):
                switch state.editMode {
                case .editing:
                    state.editMode = .editing(deletable: !state.selectedIDs.isEmpty)
                    return .none
                default:
                    return .none
                }
                
            case .onTask:
                return .run { send in
                    await send(.bookmarksUpdate(try bookmarks()))
                }
                
            case .bookmarksUpdate(let notices):
                state.bookmarkedNotices = IdentifiedArray(uniqueElements: notices)
                return .none
                
            case .editButtonTapped:
                state.editMode = .editing(deletable: false)
                return .none
                
            case .selectAllButtonTapped:
                state.selectedIDs = Set(state.bookmarkedNotices.ids)
                return .none
                
            case .deleteButtonTapped:
                switch state.editMode {
                case .editing(deletable: true):
                    state.selectedIDs.forEach {
                        state.bookmarkedNotices.remove(id: $0)
                    }
                    return .send(.binding(.set(\.selectedIDs, [])))
                default:
                    return .none
                }
                
            case .binding:
                return .none
            }
        }
    }
    
    public init() {
        
    }
}
