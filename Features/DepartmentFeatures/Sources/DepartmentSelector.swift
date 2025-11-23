//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import Dependencies
import ComposableArchitecture

@Reducer
public struct DepartmentSelectorFeature {
    @ObservableState
    public struct State: Equatable {
        public var currentDepartment: NoticeProvider?
        public var addedDepartment: IdentifiedArrayOf<NoticeProvider>

        public init(currentDepartment: NoticeProvider? = nil, addedDepartment: IdentifiedArrayOf<NoticeProvider>) {
            @Dependency(\.departments) var departments
            
            self.currentDepartment = departments.getCurrent()
            self.addedDepartment = IdentifiedArrayOf(departments.getAll().filter { $0.category == .학과 })
        }
    }
    
    public enum Action: Equatable {
        // TODO: String -> Department
        case selectDepartment(id: NoticeProvider.ID)
        case editDepartmentsButtonTapped
        case delegate(Delegate)

        public enum Delegate: Equatable {
            case editDepartment
        }
    }
    
    @Dependency(\.departments) var departments

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .selectDepartment(id: id):
                guard let department = state.addedDepartment.first(where: { $0.id == id }) else {
                    return .none
                }
                state.currentDepartment = department
                departments.changeCurrent(department)
                
                return .none

            case .editDepartmentsButtonTapped:
                return .send(.delegate(.editDepartment))

            case .delegate:
                return .none
            }
        }
    }

    public init() { }
}
