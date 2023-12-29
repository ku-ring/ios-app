import SwiftUI
import DepartmentUI
import SubscriptionFeatures
import ComposableArchitecture

public struct SubscriptionApp: View {
    @Bindable var store: StoreOf<SubscriptionAppFeature>
    
    public var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            SubscriptionView(
                store: self.store.scope(
                    state: \.subscriptionView,
                    action: \.subscriptionView
                )
            )
        } destination: { store in
            switch store.state {
            case .departmentEditor:
                if let store = store.scope(
                    state: \.departmentEditor,
                    action: \.departmentEditor
                ) {
                    DepartmentEditor(store: store)
                        .navigationTitle("Department Editor")
                }
            }
        }
    }
    
    public init(store: StoreOf<SubscriptionAppFeature>) {
        self.store = store
    }
}

#Preview {
    SubscriptionApp(
        store: Store(
            initialState: SubscriptionAppFeature.State(
                root: SubscriptionFeature.State()
            ),
            reducer: { SubscriptionAppFeature() }
        )
    )
}
