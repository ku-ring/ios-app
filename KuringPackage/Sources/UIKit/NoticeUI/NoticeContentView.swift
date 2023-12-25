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
        VStack(spacing: 0) {
            NoticeCategoryPicker(selection: $store.provider.sending(\.providerChanged))
            
            if self.store.provider == .emptyDepartment {
                NoDepartmentView()
            } else {
                NoticeList(store: self.store)
            }
        }
        .onAppear {
            store.send(.onAppear) // TODO: error on the preview canvas
        }
        .sheet(
            store: self.store.scope(
                state: \.$changeDepartment,
                action: \.changeDepartment
            )
        ) { store in
            NavigationStack {
                DepartmentSelector(store: store)
            }
            .presentationDetents([.medium])
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
