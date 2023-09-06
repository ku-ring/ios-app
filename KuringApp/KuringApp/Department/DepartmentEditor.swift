//
//  DepartmentEditor.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/04.
//

import SwiftUI
import ComposableArchitecture

struct DepartmentEditorFeature: Reducer {
    struct State: Equatable {
        /// 리스트(내 학과 | 검색결과)에 보여질 학과목록
        var departments: IdentifiedArrayOf<Department> = []
        /// 어떤 리스트가 보여질 지
        @BindingState var displayOption: Display = .myDepartment
        /// 검색어
        @BindingState var searchText: String = ""
        /// 텍스트필드 초점 여부
        @BindingState var focus: Bool = false
        
        enum Display: Hashable {
            /// 검색 결과 보여주기
            case searchResult
            /// 내 학과 보여주기
            case myDepartment
        }
    }
    
    enum Action: BindableAction {
        case deleteAllButtonTapped
        
        case clearSearchButtonTapped
        
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .deleteAllButtonTapped:
                state.departments.removeAll()
                // TODO: 전체 삭제 Alert 띄우기
                return .none
                
            case .clearSearchButtonTapped:
                state.searchText = ""
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}

struct DepartmentEditor: View {
    let store: StoreOf<DepartmentEditorFeature>
    
    @FocusState var focus: Bool
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                Text("학과를 추가하거나\n삭제할 수 있어요")
                    .font(.title)
                    .bold()
                    .padding(.vertical, 24)
                
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(focus ? Color.accentColor : .secondary)
                    
                    TextField("추가할 학과를 검색해 주세요", text: viewStore.$searchText)
                        .focused(self.$focus, equals: true)
                    
                    if !viewStore.searchText.isEmpty {
                        Button {
                            viewStore.send(.clearSearchButtonTapped)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background {
                    Capsule()
                        .stroke(Color.accentColor, lineWidth: focus ? 1 : 0)
                        .fill(Color(uiColor: #colorLiteral(red: 0.9593278766, green: 0.9626857638, blue: 0.9688413739, alpha: focus ? 0 : 1)))
                }
                .padding(.bottom, 16)
                
                DepartmentList()
                    .listStyle(.plain)
            }
            .bind(viewStore.$focus, to: self.$focus)
            .padding(.horizontal, 20)
            .toolbar {
                ToolbarItem {
                    Button("전체 삭제") {
                        viewStore.send(.deleteAllButtonTapped)
                    }
                    .tint(.accentColor)
                }
            }
        }
    }
}

struct DepartmentList: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("내 학과") // .searchResult 이면 "검색 결과"
                .foregroundStyle(.secondary)
                .font(.system(size: 14))
                .padding(.vertical, 10)
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(Department.mocks) { department in
                        DepartmentRow(department: department)
                    }
                }
            }
        }
        .padding(.horizontal, 4)
    }
}

struct DepartmentRow: View {
    let department: Department
    
    var body: some View {
        HStack {
            Text(department.korName)
            
            Spacer()
            
            Button("삭제") {
                
            }
            .tint(.secondary)
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    NavigationStack {
        DepartmentEditor(
            store: .init(
                initialState: DepartmentEditorFeature.State(focus: true),
                reducer: { DepartmentEditorFeature() }
            )
        )
    }
    .tint(Color.green)
}

#Preview {
    NavigationStack {
        DepartmentEditor(
            store: .init(
                initialState: DepartmentEditorFeature.State(focus: false),
                reducer: { DepartmentEditorFeature() }
            )
        )
    }
    .tint(Color.green)
}
