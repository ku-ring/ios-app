import ComposableArchitecture

@Reducer
public struct AppIconDetailFeature {
    @ObservableState
    public struct State: Equatable {
        // 제목과 설명 수정
        public let title: String = "앱 아이콘 변경하기"
        public let description: LocalizedStringKey = """
        이 기능은 쿠링랩에서 제공하는 베타 기능입니다.
        이 기능을 활성화 하면 **쿠링 앱의 아이콘을 변경할 수 있습니다.**
        """
        public var isEnabled: Bool = false
        
        public init(isEnabled: Bool? = nil) {
            @Dependency(\.leLabo) var leLabo
            self.isEnabled = leLabo.status(.appIcon) // 수정
        }
    }
    
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.leLabo) public var leLabo
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.isEnabled):
                leLabo.set(state.isEnabled, .appIcon) // 수정
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}

import SwiftUI

public struct AppIconDetailView: View {
    @Bindable public var store: StoreOf<AppIconDetailFeature>
    
    public let markdown: LocalizedStringKey = "# hi"
    public var body: some View {
        Form {
            Section {
                Text(store.title)
                    .font(.title3.bold())
                    .listRowSeparator(.hidden)
                
                Text(store.description)
                
                Toggle("기능 활성화", isOn: $store.isEnabled)
                    .tint(Color.accentColor)
            }
        }
        .navigationTitle(store.title)
    }
    
    public init(store: StoreOf<AppIconDetailFeature>) {
        self.store = store
    }
}

#Preview {
    AppIconDetailView(
        store: Store(
            initialState: AppIconDetailFeature.State(),
            reducer: { AppIconDetailFeature() }
        )
    )
}
