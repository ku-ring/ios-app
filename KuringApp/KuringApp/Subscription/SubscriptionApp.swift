//
//  SubscriptionApp.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/24.
//

import Model
import SwiftUI
import ComposableArchitecture

struct SubscriptionAppFeature: Reducer {
    struct State: Equatable {
        var path = StackState<Path.State>()
        var subscriptionView = SubscriptionFeature.State()
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case subscriptionView(SubscriptionFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.subscriptionView, action: /Action.subscriptionView) {
            SubscriptionFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .path:
                return .none
                
            case .subscriptionView:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
    
    struct Path: Reducer {
        enum State: Equatable {
            case departmentEditor(DepartmentEditorFeature.State)
        }
        
        enum Action {
            case departmentEditor(DepartmentEditorFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.departmentEditor, action: /Action.departmentEditor) {
                DepartmentEditorFeature()
            }
        }
    }
}

struct SubscriptionApp: View {
    let store: StoreOf<SubscriptionAppFeature>
    
    var body: some View {
        NavigationStackStore(
            self.store.scope(state: \.path, action: { .path($0) })
        ) {
            SubscriptionView(
                store: self.store.scope(
                    state: \.subscriptionView, 
                    action: { .subscriptionView($0) }
                )
            )
        } destination: { state in
            switch state {
            case .departmentEditor:
                CaseLet(
                    /SubscriptionAppFeature.Path.State.departmentEditor,
                     action: SubscriptionAppFeature.Path.Action.departmentEditor
                ) { store in
                    DepartmentEditor(store: store)
                }
            }
        }

    }
}

#Preview {
    SubscriptionApp(
        store: Store(
            initialState: SubscriptionAppFeature.State(
                subscriptionView: SubscriptionFeature.State()
            ),
            reducer: { SubscriptionAppFeature() }
        )
    )
}
