import SwiftUI
import SearchUI
import DepartmentUI
import SubscriptionUI
import NoticeFeatures
import SearchFeatures
import ComposableArchitecture

public struct NoticeApp: View {
    @Bindable var store: StoreOf<NoticeAppFeature>
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            NoticeContentView(
                store: self.store.scope(
                    state: \.noticeList,
                    action: \.noticeList
                )
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("appIconLabel", bundle: Bundle.notices)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    // MARK: 검색창 진입
                    NavigationLink(
                        state: NoticeAppFeature.Path.State.search(
                            SearchFeature.State()
                        )
                    ) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.black)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    // MARK: 푸시 알림 선택 진입
                    Button {
                        store.send(.changeSubscriptionButtonTapped)
                    } label: {
                        Image(systemName: "bell")
                            .foregroundStyle(.black)
                    }
                }
            }
            .sheet(
                store: self.store.scope(
                    state: \.$changeSubscription,
                    action: \.changeSubscription
                )
            ) { store in
                SubscriptionApp(store: store)
            }
        } destination: { store in
            switch store.state {
            case .detail:
                if let store = store.scope(state: \.detail, action: \.detail) {
                    NoticeDetailView(store: store)
                        .navigationTitle("Notice Detail View")
                }
            case .search:
                if let store = store.scope(state: \.search, action: \.search) {
                    SearchView(store: store)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle("검색하기")
                }
            case .departmentEditor:
                if let store = store.scope(state: \.departmentEditor, action: \.departmentEditor) {
                    DepartmentEditor(store: store)
                        .navigationTitle("Department Editor")
                }
            }
        }
    }
    
    public init(store: StoreOf<NoticeAppFeature>) {
        self.store = store
    }
}

#Preview {
    NoticeApp(
        store: Store(
            initialState: NoticeAppFeature.State(
                noticeList: NoticeListFeature.State()
            ),
            reducer: { NoticeAppFeature() }
        )
    )
}
