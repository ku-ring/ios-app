//
//  DepartmentSelector.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/05/21.
//

import SwiftUI
import KuringLink
import ComposableArchitecture

struct DepartmentSelector: View {
    let store: StoreOf<Major>
    @State private var searchText: String = ""
    @State private var selectedDepartment: NoticeProvider?
    @State private var allDepartments: [NoticeProvider] = []
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 12) {
                Text("전공이 무엇인가요?")
                    .font(.title3.bold())
                
                Text("맞춤 세팅을 위한 정보입니다. 외부적으로 노출되지 않습니다.")
                
                if viewStore.isLoading {
                    Label("학과 리스트를 가져오고 있습니다", systemImage: "icloud.and.arrow.down")
                        .foregroundColor(.secondary)
                } else {
                    if viewStore.onError {
                        Label("네트워크 연결 에러", systemImage: "exclamationmark.triangle")
                            .foregroundColor(.red)
                    } else {
                        HStack {
                            TextField(
                                "학과 또는 학부",
                                text: viewStore.binding(
                                    get: \.searchText,
                                    send: { .editText($0) }
                                )
                            )
                            .foregroundColor(
                                viewStore.selectedMajor != nil
                                ? .green
                                : .primary
                            )
                        }
                    }
                }
                
                
                Divider()
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading) {
                        ForEach(viewStore.allDepartments.filter({ $0.korName.contains(viewStore.searchText) })) { department in
                            Button {
                                viewStore.send(.selectDepartment(department))
                            } label: {
                                Text(department.korName)
                                    .font(.footnote)
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .onAppear { viewStore.send(.fetchAllDepartments) }
        }
    }
            
}

struct DepartmentSelector_Previews: PreviewProvider {
    static var previews: some View {
        DepartmentSelector(
            store: .init(
                initialState: .init(),
                reducer: { Major() }
            )
        )
    }
}
