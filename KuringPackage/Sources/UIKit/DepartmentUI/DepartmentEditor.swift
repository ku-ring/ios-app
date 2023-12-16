import SwiftUI
import DepartmentFeatures
import ComposableArchitecture

public struct DepartmentEditor: View {
    @Bindable private var store: StoreOf<DepartmentEditorFeature>
    
    @FocusState private var focus: DepartmentEditorFeature.State.Field?
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("학과를 추가하거나\n삭제할 수 있어요")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(red: 0.1, green: 0.12, blue: 0.15))
                .padding(.top, 28)
                .padding(.bottom, 24)
            
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
                
                TextField("추가할 학과를 검색해 주세요", text: $store.searchText)
                    .focused($focus, equals: .search)
                    .bind($store.focus, to: self.$focus)
                
                if !store.searchText.isEmpty {
                    Image(systemName: "xmark")
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
                        .onTapGesture {
                            store.send(.clearTextFieldButtonTapped)
                            focus = nil
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 7)
            .background(Color(red: 0.95, green: 0.95, blue: 0.96))
            .cornerRadius(20)
            .padding(.bottom, 16)
            
            Text(store.searchText.isEmpty ? "내 학과" : "검색 결과")
                .font(.system(size: 14))
                .foregroundStyle(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
                .padding(.horizontal, 4)
                .padding(.vertical, 10)
            
            if store.searchText.isEmpty {
                // 내학과
                ScrollView {
                    ForEach(store.myDepartments) { myDepartment in
                        Button {
                            store.send(.deleteMyDepartmentButtonTapped(id: myDepartment.id))
                        } label: {
                            Text("삭제")
                                .foregroundStyle(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
                        }
                    }
                }
            } else {
                // 검색결과
                ScrollView {
                    ForEach(store.results) { result in
                        Button {
                            if store.myDepartments.contains(result) {
                                store.send(.cancelAdditionButtonTapped(id: result.id))
                            } else {
                                store.send(.addDepartmentButtonTapped(id: result.id))
                            }
                        } label: {
                            Image(
                                systemName: store.myDepartments.contains(result)
                                ? "checkmark.circle.fill"
                                : "plus.circle"
                            )
                            .foregroundStyle(
                                store.myDepartments.contains(result)
                                ? Color.accentColor
                                : Color.black.opacity(0.1)
                            )
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
                Button("전체 삭제") {
                    store.send(.deleteAllMyDepartmentButtonTapped)
                }
                .tint(.accentColor)
                .disabled(store.myDepartments.isEmpty)
            }
        }
        .alert(
            store: store.scope(
                state: \.$alert,
                action: \.alert
            )
        )
    }
    
    public init(store: StoreOf<DepartmentEditorFeature>) {
        self.store = store
    }
}

#Preview {
    DepartmentEditor(
        store: Store(
            initialState: DepartmentEditorFeature.State(),
            reducer: { DepartmentEditorFeature() }
        )
    )
}
