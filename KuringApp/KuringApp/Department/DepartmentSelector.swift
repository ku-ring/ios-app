//
//  DepartmentSelector.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/24.
//

import Model
import SwiftUI
import ComposableArchitecture

struct DepartmentSelectorFeature: Reducer {
    struct State: Equatable {
        var currentDepartment: Department?
        var addedDepartment: IdentifiedArrayOf<Department>
    }
    
    enum Action {
        // TODO: String -> Department
        case selectDepartment(id: Department.ID)
        case editDepartmentsButtonTapped
        case delegate(Delegate)
        
        enum Delegate {
            case editDepartment
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .selectDepartment(id: id):
                guard let department = state.addedDepartment.first(where: { $0.id == id }) else {
                    return .none
                    
                }
                state.currentDepartment = department
                return .none
            
            case .editDepartmentsButtonTapped:
                return .send(.delegate(.editDepartment))
                
            case .delegate:
                return .none
            }
        }
    }
}

struct DepartmentSelector: View {
    let store: StoreOf<DepartmentSelectorFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List {
                Section {
                    ForEach(viewStore.addedDepartment) { department in
                        Button {
                            viewStore.send(.selectDepartment(id: department.id))
                        } label: {
                            Label(
                                department.korName,
                                systemImage: department == viewStore.currentDepartment
                                ? "checkmark.circle.fill"
                                : "circle"
                            )
                        }
                    }
                }
                
                Button("내 학과 편집하기") {
                    viewStore.send(.editDepartmentsButtonTapped)
                }
            }
            .navigationTitle("Department Selector")
        }
    }
}

#Preview {
    NavigationStack {
        DepartmentSelector(
            store: Store(
                initialState: DepartmentSelectorFeature.State(addedDepartment: [.전기전자공학부, .컴퓨터공학부, .산업디자인학과]),
                reducer: { DepartmentSelectorFeature() }
            )
        )
    }
}
