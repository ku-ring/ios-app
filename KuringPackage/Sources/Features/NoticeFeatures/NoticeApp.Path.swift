import Models
import SearchFeatures
import DepartmentFeatures
import ComposableArchitecture

extension NoticeAppFeature {
    @Reducer
    public struct Path {
        @ObservableState
        public enum State: Equatable {
            case detail(NoticeDetailFeature.State)
            case search(SearchFeature.State)
            case departmentEditor(DepartmentEditorFeature.State)
        }
        
        public enum Action {
            case detail(NoticeDetailFeature.Action)
            case search(SearchFeature.Action)
            case departmentEditor(DepartmentEditorFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: /State.detail, action: /Action.detail) {
                NoticeDetailFeature()
            }
            
            Scope(state: /State.search, action: /Action.search) {
                SearchFeature()
            }
            
            Scope(state: /State.departmentEditor, action: /Action.departmentEditor) {
                DepartmentEditorFeature()
            }
        }
    }

}

