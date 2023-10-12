//
//  App.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/22.
//

import Model
import SwiftUI
import ComposableArchitecture

struct NoticeAppFeature: Reducer {
    struct State: Equatable {
        var path = StackState<Path.State>()
        var noticeList = NoticeListFeature.State()
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case noticeList(NoticeListFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.noticeList, action: /Action.noticeList) {
            NoticeListFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .path:
                return .none
                
            case let .noticeList(.delegate(delegate)):
                switch delegate {
                case .editDepartment:
                    state.path.removeAll()
                    state.path.append(
                        Path.State.departmentEditor(
                            // TODO: init parameter 수정 (현재는 테스트용)
                            DepartmentEditorFeature.State(
                                myDepartments: IdentifiedArray(uniqueElements: NoticeProvider.departments),
                                results: IdentifiedArray(uniqueElements: NoticeProvider.departments)
                            )
                        )
                    )
                    return .none
                }
                
            case .noticeList:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}

struct NoticeAppView: View {
    let store: StoreOf<NoticeAppFeature>
    
    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) })) {
            NoticeList(
                store: self.store.scope(
                    state: \.noticeList,
                    action: { .noticeList($0) }
                )
            )
        } destination: { state in
            switch state {
            case .detail:
                CaseLet(
                    /NoticeAppFeature.Path.State.detail,
                     action: NoticeAppFeature.Path.Action.detail
                ) { store in
                    NoticeDetailView(store: store)
                        .navigationTitle("Notice Detail View")
                }
                
            case .search:
                CaseLet(
                    /NoticeAppFeature.Path.State.search,
                     action: NoticeAppFeature.Path.Action.search
                ) { store in
                    SearchView(store: store)
                        .navigationTitle("Search View")
                }
                
            case .departmentEditor:
                CaseLet(
                    /NoticeAppFeature.Path.State.departmentEditor,
                     action: NoticeAppFeature.Path.Action.departmentEditor
                ) { store in
                    DepartmentEditor(store: store)
                        .navigationTitle("Department Editor")
                }
            }
        }

    }
}

#Preview {
    NoticeAppView(
        store: Store(
            initialState: NoticeAppFeature.State(
                noticeList: NoticeListFeature.State(notices: [.random])
            ),
            reducer: { NoticeAppFeature() }
        )
    )
}
