//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import DepartmentUI
import NoticeFeatures
import DepartmentFeatures
import ComposableArchitecture

struct NoticeContentView: View {
    @Bindable var store: StoreOf<NoticeListFeature>
    
    /// - NOTE: NoticeList 만 제외하고 나머지는 NotiecApp 단으로 옮겨야 하는가?
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                NoticeCategoryPicker(selection: $store.provider.sending(\.providerChanged))
                
                Divider()
                    .frame(height: 0.25)
                
                if self.store.provider == .emptyDepartment {
                    NoDepartmentView()
                }
                // MARK: 커뮤니케이션디자인학과의 경우에만 예외로 다른 화면을 넣어줘야 함
                else if self.store.provider.hostPrefix == "ccd" {
                    Section {
                        CannotFetchDepartmentView()
                    } header: {
                        VStack(spacing: 0) {
                            DepartmentSelectorLink(
                                department: self.store.provider,
                                isLoading: $store.isLoading.sending(\.loadingChanged)
                            ) {
                                self.store.send(.changeDepartmentButtonTapped)
                            }
                            
                            Divider()
                                .frame(height: 0.25)
                        }
                    }
                } else {
                    NoticeList(store: self.store)
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
            .sheet(
                item: $store.scope(
                    state: \.changeDepartment,
                    action: \.changeDepartment
                )
            ) { store in
                NavigationStack {
                    DepartmentSelector(store: store)
                }
                .presentationDetents([.medium])
            }
            BotFloatButton()
        }
    }
}

#Preview {
    NavigationStack {
        NoticeContentView(
            store: Store(
                initialState: NoticeListFeature.State(),
                reducer: { NoticeListFeature() }
            )
        )
    }
}
