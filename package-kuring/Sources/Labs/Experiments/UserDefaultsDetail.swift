//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import ComposableArchitecture

@Reducer
public struct UserDefaultsDetailFeature {
    @ObservableState
    public struct State: Equatable {
        public let title: String = "설정 값 변경하기"
        public let description: LocalizedStringKey = """
        이 기능은 쿠링랩에서 제공하는 베타 기능이에요.
        이 기능을 활성화 하면 **앱에 저장된 설정 값을 변경**할 수 있어요.
        """
        public var isEnabled: Bool = false
        
        public init(isEnabled: Bool? = nil) {
            @Dependency(\.leLabo) var leLabo
            self.isEnabled = leLabo.status(.userDefaults)
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
                leLabo.set(state.isEnabled, .userDefaults)
                return .none

            case .binding:
                return .none
            }
        }
    }
}

import SwiftUI

public struct UserDefaultsDetailView: View {
    @Bindable public var store: StoreOf<UserDefaultsDetailFeature>
    
//    @AppStorage
    @State private var firstLaunch: Bool = true
    @State private var isCustomNoticationEnabled: Bool = true
    @State private var subscribedUnivCategories: String = ""
    @State private var subscribedDeptCategories: String = ""

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
            
            Section {
                Toggle(
                    "service.firstlaunch",
                    isOn: $firstLaunch
                )
                
                Toggle(
                    "service.notification.custom",
                    isOn: $isCustomNoticationEnabled
                )
                
                HStack {
                    Text("service.subscription.univ")
                    
                    Spacer()
                    
                    TextField("", text: $subscribedUnivCategories)
                }
                
                HStack {
                    Text("service.subscription.department")
                    
                    Spacer()
                    
                    TextField("", text: $subscribedDeptCategories)
                }
            }
            .font(.footnote)
            .tint(Color.accentColor)
        }
        .navigationTitle(store.title)
    }

    public init(store: StoreOf<UserDefaultsDetailFeature>) {
        self.store = store
    }
}

#Preview {
    UserDefaultsDetailView(
        store: Store(
            initialState: UserDefaultsDetailFeature.State(),
            reducer: { UserDefaultsDetailFeature() }
        )
    )
}
