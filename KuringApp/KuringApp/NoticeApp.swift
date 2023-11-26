//
//  App.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/22.
//

import Model
import SwiftUI
import NoticeListFeature
import ComposableArchitecture

struct NoticeAppFeature: Reducer {
    struct State: Equatable {
        // MARK: 네비게이션
        
        /// 루트
        var noticeList = NoticeListFeature.State()
        /// 스택 네비게이션
        var path = StackState<Path.State>()
        /// 트리 네비게이션 - ``SubscriptionAppFeature``
        @PresentationState var changeSubscription: SubscriptionAppFeature.State?
    }
    
    enum Action {
        /// 루트(``NoticeListFeature``) 액션
        case noticeList(NoticeListFeature.Action)
        
        /// 스택 네비게이션 액션 (``NoticeAppFeature/Path``)
        case path(StackAction<Path.State, Path.Action>)
        
        /// 구독 변경 버튼을 탭한 경우
        case changeSubscriptionButtonTapped
        
        /// ``SubscriptionAppFeature`` 의 Presentation 액션
        case changeSubscription(PresentationAction<SubscriptionAppFeature.Action>)
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
                
            case .changeSubscription(.presented(.subscriptionView(.subscriptionResponse))):
                /// ``SubscriptionAppFeature`` 액션
                state.changeSubscription = nil
                return .none
                
            case .changeSubscriptionButtonTapped:
                state.changeSubscription = SubscriptionAppFeature.State()
                return .none
                
            case .noticeList, .changeSubscription:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
        .ifLet(\.$changeSubscription, action: /Action.changeSubscription) {
            SubscriptionAppFeature()
        }
    }
}

struct NoticeAppView: View {
    let store: StoreOf<NoticeAppFeature>
    
    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) })) {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                NoticeContentView(
                    store: self.store.scope(
                        state: \.noticeList,
                        action: { .noticeList($0) }
                    )
                )
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Image("appIconLabel", bundle: Bundle.noticeList)
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            // TODO: - to SearchView
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(Color.black)
                        }
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        // MARK: 푸시 알림 선택 진입
                        Button {
                            viewStore.send(.changeSubscriptionButtonTapped)
                        } label: {
                            Image(systemName: "bell")
                                .foregroundStyle(.black)
                        }
                    }
                }
                .sheet(
                    store: self.store.scope(
                        state: \.$changeSubscription,
                        action: { .changeSubscription($0) }
                    )
                ) { store in
                    SubscriptionApp(store: store)
                }
            }
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
                noticeList: NoticeListFeature.State()
            ),
            reducer: { NoticeAppFeature() }
        )
    )
}
