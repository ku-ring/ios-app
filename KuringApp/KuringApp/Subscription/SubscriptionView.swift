//
//  SubscriptionView.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/24.
//

import Model
import SwiftUI
import ComposableArchitecture

struct SubscriptionFeature: Reducer {
    struct State: Equatable {
        @BindingState var subscriptionType: SubscriptionType = .university
        
        var myDepartments: IdentifiedArrayOf<Department> = []
        
        enum SubscriptionType: Equatable {
            case university
            case department
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case confirmButtonTapped
        case editDepartmentsButtonTapped
    }
    
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .binding:
                return .none
                
            case .confirmButtonTapped:
                return .none
                
            case .editDepartmentsButtonTapped:
                return .none
            }
        }
    }
}

struct SubscriptionView: View {
    let store: StoreOf<SubscriptionFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List {
                Text("알림 받고 싶은 카테고리를 선택해 주세요")
                
                /**
                 - `viewStore.$subscriptionType`
                 */
                Section {
                    Picker("", selection: viewStore.$subscriptionType) {
                        Text("일반 카테고리")
                            .tag(SubscriptionFeature.State.SubscriptionType.university)
                        
                        Text("학과 카테고리")
                            .tag(SubscriptionFeature.State.SubscriptionType.department)
                    }
                    .pickerStyle(.segmented)
                }
                
                /**
                 - `.editDepartmentsButtonTapped`
                 */
                if viewStore.subscriptionType == .department {
                    Section {
                        Button(
                            viewStore.myDepartments.isEmpty
                            ? "학과 추가하기"
                            : "학과 편집하기"
                        ) {
                            viewStore.send(.editDepartmentsButtonTapped)
                        }
                        
                        NavigationLink(
                            state: SubscriptionAppFeature.Path.State.departmentEditor(
                                // TODO: init parameter 수정 (현재는 테스트용)
                                DepartmentEditorFeature.State(
                                    myDepartments: [.전기전자공학부, .컴퓨터공학부],
                                    results: [.전기전자공학부, .컴퓨터공학부, .산업디자인학과]
                                )
                            )
                        ) {
                            Text(
                                viewStore.myDepartments.isEmpty
                                ? "학과 추가하기"
                                : "학과 편집하기"
                            )
                        }
                    }
                }
                
            }
            .navigationTitle("Subscription View")
            .toolbar {
                Button("완료") {
                    viewStore.send(.confirmButtonTapped)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SubscriptionView(
            store: Store(
                initialState: SubscriptionFeature.State(),
                reducer: { SubscriptionFeature() }
            )
        )
    }
}
