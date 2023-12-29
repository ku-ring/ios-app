import Foundation
import DepartmentFeatures
import ComposableArchitecture

extension SubscriptionAppFeature {
    @Reducer
    public struct Path {
        @ObservableState
        public enum State: Equatable {
            case departmentEditor(DepartmentEditorFeature.State)
        }
        
        public enum Action: Equatable {
            case departmentEditor(DepartmentEditorFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.departmentEditor, action: \.departmentEditor) {
                DepartmentEditorFeature()
            }
        }
        
        public init() { }
    }
}
