//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

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

        public enum Action: Equatable {
            case detail(NoticeDetailFeature.Action)
            case search(SearchFeature.Action)
            case departmentEditor(DepartmentEditorFeature.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.detail, action: \.detail) {
                NoticeDetailFeature()
            }

            Scope(state: \.search, action: \.search) {
                SearchFeature()
            }

            Scope(state: \.departmentEditor, action: \.departmentEditor) {
                DepartmentEditorFeature()
            }
        }
    }
}
