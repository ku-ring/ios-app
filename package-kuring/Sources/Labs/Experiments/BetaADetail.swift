//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import ComposableArchitecture

@Reducer
public struct BetaADetailFeature {
    @ObservableState
    public struct State: Equatable {
        public let title: String = "베타 기능 A"
        public let description: LocalizedStringKey = """
        이 기능은 쿠링랩에서 제공하는 베타 기능이에요.
        이 기능을 활성화 하면 **각 공지별로 몇 번이나 북마크 되었는지 확인**할 수 있어요.
        """
        public var isEnabled: Bool = false

        public init(isEnabled: Bool? = nil) {
            @Dependency(\.leLabo) var leLabo
            self.isEnabled = leLabo.status(.betaA)
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
                leLabo.set(state.isEnabled, .betaA)
                return .none

            case .binding:
                return .none
            }
        }
    }
}

import SwiftUI

public struct BetaADetailView: View {
    @Bindable public var store: StoreOf<BetaADetailFeature>

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

    public init(store: StoreOf<BetaADetailFeature>) {
        self.store = store
    }
}

#Preview {
    BetaADetailView(
        store: Store(
            initialState: BetaADetailFeature.State(),
            reducer: { BetaADetailFeature() }
        )
    )
}
