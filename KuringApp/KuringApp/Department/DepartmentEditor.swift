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
        var myDepartments: IdentifiedArrayOf<NoticeProvider> = []
        var results: IdentifiedArrayOf<NoticeProvider> = []
        
        @BindingState var searchText: String = ""
        @BindingState var focus: Field? = .search
        
        enum Field {
            case search
        }
        
        @PresentationState var alert: AlertState<Action.Alert>?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        /// 학과 추가 버튼 눌렀을 때
        case addDepartmentButtonTapped(id: NoticeProvider.ID)
        /// 추가했던 학과 취소 버튼 눌렀을 때
        case cancelAdditionButtonTapped(id: NoticeProvider.ID)
        /// 내 학과 삭제 버튼 눌렀을 때
        case deleteMyDepartmentButtonTapped(id: NoticeProvider.ID)
        /// 내 학과 전체삭제 버튼 눌렀을 때
        case deleteAllMyDepartmentButtonTapped
        /// 텍스트 필드의 xmark를 눌렀을 때
        case clearTextFieldButtonTapped
        
        /// 알림
        enum Alert: Equatable {
            /// 개별 학과 삭제 알림 시 삭제 버튼 눌렀을 때
            case confirmDelete(id: NoticeProvider.ID)
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
                guard !state.myDepartments.contains(department) else {
                    return .none
                }
                state.myDepartments.append(department)
                return .none
                
            case let .cancelAdditionButtonTapped(id: id):
                state.myDepartments.remove(id: id)
                return .none
                
            case let .deleteMyDepartmentButtonTapped(id: id):
                guard let department = state.myDepartments.first(where: { $0.id == id }) else {
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
            case .clearTextFieldButtonTapped:
                state.searchText.removeAll()
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
                HStack {
                    Text("학과를 추가하거나\n삭제할 수 있어요")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 0.1, green: 0.12, blue: 0.15))
                    Spacer()
                }
                .padding(.top, 28)
                .padding(.bottom, 24)
                
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
                    
                    TextField("추가할 학과를 검색해 주세요", text: viewStore.$searchText)
                        .focused($focus, equals: .search)
                        .bind(viewStore.$focus, to: self.$focus)
                    
                    if !viewStore.searchText.isEmpty {
                        Image(systemName: "xmark")
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
                            .onTapGesture {
                                viewStore.send(.clearTextFieldButtonTapped)
                                focus = nil
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 7)
                .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                .cornerRadius(20)
                .padding(.bottom, 16)
                
                HStack(alignment: .center, spacing: 10) {
                    Text(viewStore.searchText.isEmpty ? "내 학과" : "검색 결과")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
                    Spacer()
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 10)
                
                if viewStore.searchText.isEmpty {
                    // 내학과
                    ScrollView {
                        ForEach(viewStore.myDepartments) { myDepartment in
                            HStack(alignment: .center) {
                                Text(myDepartment.korName)
                                Spacer()
                                Button {
                                    viewStore.send(.deleteMyDepartmentButtonTapped(id: myDepartment.id))
                                } label: {
                                    Text("삭제")
                                        .foregroundStyle(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
                                }
                            }
                            .padding(.horizontal, 4)
                            .padding(.vertical, 10)
                        }
                    }
                } else {
                    // 검색결과
                    ScrollView {
                        ForEach(viewStore.results) { result in
                            HStack(alignment: .center) {
                                Text(result.korName)
                                
                                Spacer()
                                
                                Button {
                                    if viewStore.myDepartments.contains(result) {
                                        viewStore.send(.cancelAdditionButtonTapped(id: result.id))
                                    } else {
                                        viewStore.send(.addDepartmentButtonTapped(id: result.id))
                                    }
                                } label: {
                                    let isSelected = viewStore.myDepartments.contains(result)
                                    Image(
                                        systemName: isSelected
                                        ? "checkmark.circle.fill"
                                        : "plus.circle"
                                    )
                                    .foregroundStyle(
                                        isSelected
                                        ? Color.accentColor
                                        : Color.black.opacity(0.1)
                                    )
                                }
                            }
                            .padding(.horizontal, 4)
                            .padding(.vertical, 10)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewStore.send(.deleteAllMyDepartmentButtonTapped)
                        focus = .search
                    } label: {
                        Text("전체 삭제")
                            .foregroundStyle(
                                viewStore.myDepartments.isEmpty
                                ? Color(red: 0.21, green: 0.21, blue: 0.21).opacity(0.5)
                                : Color.accentColor
                            )
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
                    myDepartments: [
                        NoticeProvider.departments[0],
                        NoticeProvider.departments[1]
                    ],
                    results: [
                        NoticeProvider.departments[0],
                        NoticeProvider.departments[1],
                        NoticeProvider.departments[2]
                    ]
                ),
                reducer: { DepartmentEditorFeature() }
            )
        )
        .navigationTitle("Department Editor")
//        .toolbarTitleDisplayMode(.inline)
    }
}
