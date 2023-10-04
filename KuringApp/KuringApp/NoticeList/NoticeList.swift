//
//  NoticeList.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/22.
//

import Model
import SwiftUI
import ComposableArchitecture

struct NoticeListFeature: Reducer {
    struct State: Equatable {
        var notices: IdentifiedArrayOf<Notice> = []

        var currentDepartment: Department?
        @PresentationState var changeDepartment: DepartmentSelectorFeature.State?
        
        // TODO: (고민포인트) AppFeature 단으로 (부모 리듀서) 로 옮길 필요는 없을까? - 도메인에 대한 고민
        @PresentationState var changeSubscription: SubscriptionAppFeature.State?
    }
    
    enum Action {
        case changeDepartmentButtonTapped
        case changeSubscriptionButtonTapped
        
        case changeDepartment(PresentationAction<DepartmentSelectorFeature.Action>)
        case changeSubscription(PresentationAction<SubscriptionAppFeature.Action>)
        
        case delegate(Delegate)
        
        enum Delegate {
            case editDepartment
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .changeDepartmentButtonTapped:
                state.changeDepartment = DepartmentSelectorFeature.State(
                    currentDepartment: state.currentDepartment,
                    addedDepartment: [.전기전자공학부, .컴퓨터공학부, .산업디자인학과]
                )
                return .none
                
            case .changeSubscriptionButtonTapped:
                state.changeSubscription = SubscriptionAppFeature.State()
                return .none
                
            case let .changeDepartment(.presented(.delegate(delegate))):
                switch delegate {
                case .editDepartment:
                    state.changeDepartment = nil
                    return .send(.delegate(.editDepartment))
                }
                
                // TODO: Delegate
            case .changeDepartment(.presented(.selectDepartment)):
                guard let selectedDepartment = state.changeDepartment?.currentDepartment else {
                    return .none
                }
                state.currentDepartment = selectedDepartment
                return .none
                
            case .changeSubscription(.presented(.subscriptionView(.confirmButtonTapped))):
                state.changeSubscription = nil
                return .none
                
            case .changeDepartment:
                return .none

            case .changeSubscription:
                return .none
                
            case .delegate:
                return .none
            }
        }
        .ifLet(\.$changeDepartment, action: /Action.changeDepartment) {
            DepartmentSelectorFeature()
        }
        .ifLet(\.$changeSubscription, action: /Action.changeSubscription) {
            SubscriptionAppFeature()
        }
    }
}

struct NoticeList: View {
    let store: StoreOf<NoticeListFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List {
                Button((viewStore.currentDepartment ?? .전기전자공학부).korName) {
                    viewStore.send(.changeDepartmentButtonTapped)
                }
                
                ForEach(viewStore.state.notices) { notice in
                    NavigationLink(
                        state: NoticeAppFeature.Path.State.detail(
                            NoticeDetailFeature.State(notice: notice)
                        )
                    ) {
                        VStack(alignment: .leading) {
                            Text(notice.subject)
                            
                            Text(notice.postedDate)
                        }
                    }
                }
            }
            .navigationTitle("Notice List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(
                        state: NoticeAppFeature.Path.State.search(
                            SearchFeature.State()
                        )
                    ) {
                        Image(systemName: "magnifyingglass")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewStore.send(.changeSubscriptionButtonTapped)
                    } label: {
                        Image(systemName: "bell")
                    }
                }
            }
            .sheet(
                store: self.store.scope(
                    state: \.$changeDepartment,
                    action: { .changeDepartment($0) }
                )
            ) { store in
                NavigationStack {
                    DepartmentSelector(store: store)
                        .navigationTitle("Department Selector")
                }
            }
            .sheet(
                store: self.store.scope(
                    state: \.$changeSubscription,
                    action: { .changeSubscription($0) }
                )
            ) { store in
                NavigationStack {
                    SubscriptionApp(store: store)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        NoticeList(
            store: Store(
                initialState: NoticeListFeature.State(notices: [.random]),
                reducer: { NoticeListFeature() }
            )
        )
    }
}
