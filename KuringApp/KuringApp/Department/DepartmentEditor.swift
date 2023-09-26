//
//  DepartmentEditor.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/24.
//

import Model
import SwiftUI
import ComposableArchitecture

struct DepartmentEditorFeature: Reducer {
    struct State: Equatable {
        var myDepartments: IdentifiedArrayOf<Department> = []
        var results: IdentifiedArrayOf<Department> = []
        
        @BindingState var searchText: String = ""
        @BindingState var focus: Field? = .search
        
        enum Field {
            case search
        }
        
        @PresentationState var alert: AlertState<Action.Alert>?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        /// 학과 추가 버튼 눌렀을 때
        case addDepartmentButtonTapped(id: Department.ID)
        /// 추가했던 학과 취소 버튼 눌렀을 때
        case cancelAdditionButtonTapped(id: Department.ID)
        /// 내 학과 삭제 버튼 눌렀을 때
        case deleteMyDepartmentButtonTapped(id: Department.ID)
        /// 내 학과 전체삭제 버튼 눌렀을 때
        case deleteAllMyDepartmentButtonTapped
        
        /// 알림
        enum Alert: Equatable {
            /// 개별 학과 삭제 알림 시 삭제 버튼 눌렀을 때
            case confirmDelete(id: Department.ID)
            /// 전체 삭제 알림 시 삭제 버튼 눌렀을 때
            case confirmDeleteAll
        }
        /// 알림 관련 액션
        case alert(PresentationAction<Alert>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case let .addDepartmentButtonTapped(id: id):
                guard let department = state.results.first(where: { $0.id == id }) else {
                    return .none
                }
                state.myDepartments.append(department)
                return .none
                
            case let .cancelAdditionButtonTapped(id: id):
                state.myDepartments.remove(id: id)
                return .none
                
            case let .deleteMyDepartmentButtonTapped(id: id):
                guard let department = state.results.first(where: { $0.id == id }) else {
                    return .none
                }
                state.alert = AlertState {
                    TextState("\(department.korName)를\n삭제하시겠습니까?")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("취소하기")
                    }
                    
                    ButtonState(role: .destructive, action: .confirmDelete(id: id)) {
                        TextState("삭제하기")
                    }
                }
                return .none
                
            case .deleteAllMyDepartmentButtonTapped:
                state.alert = AlertState {
                    TextState("모든 학과를 삭제하시겠습니까?")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("취소하기")
                    }
                    
                    ButtonState(role: .destructive, action: .confirmDeleteAll) {
                        TextState("삭제하기")
                    }
                }
                return .none
                
                // MARK: Alert
            case let .alert(.presented(alertAction)):
                switch alertAction {
                case let .confirmDelete(id: id):
                    state.myDepartments.remove(id: id)
                    return .none
                case .confirmDeleteAll:
                    state.myDepartments.removeAll()
                    return .none
                }
                
            case .alert(.dismiss):
                return .none
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
    }
}

struct DepartmentEditor: View {
    let store: StoreOf<DepartmentEditorFeature>
    
    @FocusState private var focus: DepartmentEditorFeature.State.Field?
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                List {
                    Text("학과를 추가하거나 삭제할 수 있어요")
                    
                    /**
                     - `viewStore.$searchText`
                     - `bind(viewStore.$focus, to: $focus)`
                     */
                    Section {
                        TextField("추가할 학과를 검색해 주세요", text: viewStore.$searchText)
                            .focused($focus, equals: .search)
                            .bind(viewStore.$focus, to: self.$focus)
                    }
                    
                    /**
                     - `viewStore.myDepartments`
                     - `.deleteMyDepartmentButtonTapped`
                     */
                    Section {
                        ForEach(viewStore.myDepartments) { myDepartment in
                            HStack {
                                Text(myDepartment.korName)
                                
                                Spacer()
                                
                                Button("삭제") {
                                    viewStore.send(.deleteMyDepartmentButtonTapped(id: myDepartment.id))
                                }
                            }
                        }
                    } header: {
                        Text("내 학과")
                    }
                    
                    /**
                     - `viewStore.results`
                     - `addDepartmentButtonTapped`
                     - `cancelAdditionButtonTapped`
                     */
                    Section {
                        ForEach(viewStore.results) { result in
                            HStack {
                                Text(result.korName)
                                
                                Spacer()
                                
                                Button {
                                    if viewStore.myDepartments.contains(result) {
                                        viewStore.send(.cancelAdditionButtonTapped(id: result.id))
                                    } else {
                                        viewStore.send(.addDepartmentButtonTapped(id: result.id))
                                    }
                                } label: {
                                    Image(
                                        systemName: viewStore.myDepartments.contains(result)
                                        ? "checkmark.circle.fill"
                                        : "plus.circle"
                                    )
                                }
                            }
                        }
                    } header: {
                        Text("검색 결과")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("전체 삭제") {
                        viewStore.send(.deleteAllMyDepartmentButtonTapped)
                    }
                    .disabled(viewStore.myDepartments.isEmpty)
                }
            }
            .alert(
                store: self.store.scope(
                    state: \.$alert,
                    action: { .alert($0) }
                )
            )
        }
    }
}


#Preview {
    NavigationStack {
        DepartmentEditor(
            store: Store(
                initialState: DepartmentEditorFeature.State(
                    myDepartments: [.전기전자공학부, .컴퓨터공학부],
                    results: [.전기전자공학부, .컴퓨터공학부, .산업디자인학과]
                ),
                reducer: { DepartmentEditorFeature() }
            )
        )
        .navigationTitle("Department Editor")
    }
}
