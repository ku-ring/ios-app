//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import ColorSet
import DepartmentFeatures
import ComposableArchitecture

public struct DepartmentEditor: View {
    @Bindable var store: StoreOf<DepartmentEditorFeature>

    @FocusState private var focus: DepartmentEditorFeature.State.Field?

    public var body: some View {
        VStack(alignment: .leading) {
            Text("학과를 추가하거나\n삭제할 수 있어요")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.Kuring.title)
                .padding(.top, 28)
                .padding(.bottom, 24)

            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Color.Kuring.gray400)

                TextField("추가할 학과를 검색해 주세요", text: $store.searchText)
                    .focused($focus, equals: .search)
                    .autocorrectionDisabled()
                    .bind($store.focus, to: self.$focus)

                if !store.searchText.isEmpty {
                    Image(systemName: "xmark")
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color.Kuring.gray400)
                        .onTapGesture {
                            store.send(.clearTextFieldButtonTapped)
                            focus = nil
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 7)
            .background(Color.Kuring.gray100)
            .cornerRadius(20)
            .padding(.bottom, 16)

            Text(store.searchText.isEmpty ? "내 학과" : "검색 결과")
                .font(.system(size: 14))
                .foregroundStyle(Color.Kuring.caption1)
                .padding(.horizontal, 4)
                .padding(.vertical, 10)

            if store.searchText.isEmpty {
                // 내학과
                ScrollView {
                    ForEach(store.myDepartments) { myDepartment in
                        DepartmentRow(
                            department: myDepartment,
                            style: .delete
                        ) {
                            store.send(.deleteMyDepartmentButtonTapped(id: myDepartment.id))
                        }
                    }
                }
            } else {
                // 검색결과
                ScrollView {
                    ForEach(store.results) { result in
                        DepartmentRow(
                            department: result,
                            style: .radio(store.myDepartments.contains(result))
                        ) {
                            if store.myDepartments.contains(result) {
                                store.send(.cancelAdditionButtonTapped(id: result.id))
                            } else {
                                store.send(.addDepartmentButtonTapped(id: result.id))
                            }
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Color.Kuring.bg)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("전체 삭제") {
                    store.send(.deleteAllMyDepartmentButtonTapped)
                }
                .tint(Color.Kuring.primary)
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

    public init(store: StoreOf<DepartmentEditorFeature>, focus: DepartmentEditorFeature.State.Field? = nil) {
        self.store = store
        self.focus = focus
    }
}

#Preview {
    NavigationStack {
        DepartmentEditor(
            store: Store(
                initialState: DepartmentEditorFeature.State(
                    myDepartments: [
                        NoticeProvider.departments[0],
                        NoticeProvider.departments[1],
                    ],
                    results: [
                        NoticeProvider.departments[0],
                        NoticeProvider.departments[1],
                        NoticeProvider.departments[2],
                    ]
                ),
                reducer: { DepartmentEditorFeature() }
            )
        )
        .navigationTitle("Department Editor")
    }
}
