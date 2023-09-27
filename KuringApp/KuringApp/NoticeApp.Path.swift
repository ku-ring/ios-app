//
//  Path.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/22.
//

import Model
import SwiftUI
import ComposableArchitecture

extension NoticeAppFeature {
    struct Path: Reducer {
        enum State {
            case detail(NoticeDetailFeature.State)
            case search(SearchFeature.State)
            case departmentEditor(DepartmentEditorFeature.State)
        }
        
        enum Action {
            case detail(NoticeDetailFeature.Action)
            case search(SearchFeature.Action)
            case departmentEditor(DepartmentEditorFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
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
