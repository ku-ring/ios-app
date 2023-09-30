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
        var currentDepartment: NoticeProvider?
        var addedDepartment: IdentifiedArrayOf<NoticeProvider>
    }
    
    enum Action: Equatable {
        // TODO: String -> Department
        case selectDepartment(id: NoticeProvider.ID)
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
            VStack {
                HStack(alignment: .center, spacing: 10) {
                    Text("대표 학과 선택")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.black)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 12)
                .frame(width: 375, alignment: .leading)
                
                ScrollView {
                    ForEach(viewStore.addedDepartment) { department in
                        HStack {
                            Text(department.id)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Image(
                                systemName: department == viewStore.currentDepartment
                                ? "checkmark.circle.fill"
                                : "circle"
                            )
                            .foregroundStyle(
                                department == viewStore.currentDepartment
                                ? Color(red: 0.24, green: 0.74, blue: 0.5)
                                : Color.black.opacity(0.1)
                            )
                            .frame(width: 20, height: 20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(.white)
                        .onTapGesture {
                            viewStore.send(.selectDepartment(id: department.id))
                        }
                    }
                }
                
                topBlurButton(
                    "내 학과 편집하기",
                    fontColor:Color(red: 0.24, green: 0.74, blue: 0.5),
                    backgroundColor: Color(red: 0.24, green: 0.74, blue: 0.5).opacity(0.15)
                )
                .padding(.horizontal, 20)
            }
        }
    }
    
    // TODO: 디자인 시스템 분리 - 상단에 블러가 존재하는 버튼
    @ViewBuilder
    private func topBlurButton(_ title: String, fontColor: Color, backgroundColor: Color) -> some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(fontColor)
            Spacer()
        }
        .padding(.horizontal, 50)
        .padding(.vertical, 16)
        .frame(height: 50, alignment: .center)
        .background(backgroundColor)
        .cornerRadius(100)
        .background {
            LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .white]), startPoint: .top, endPoint: .bottom)
                .offset(x: 0, y: -32)
        }
    }
}

#Preview {
    NavigationStack {
        DepartmentSelector(
            store: Store(
                initialState: DepartmentSelectorFeature.State(
                    addedDepartment: [
                        NoticeProvider.departments[0],
                        NoticeProvider.departments[1],
                        NoticeProvider.departments[2],
                    ]
                ),
                reducer: { DepartmentSelectorFeature() }
            )
        )
    }
}
