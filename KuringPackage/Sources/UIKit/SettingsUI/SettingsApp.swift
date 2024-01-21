//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Labs
import SwiftUI
import SubscriptionUI
import SettingsFeatures
import ComposableArchitecture

public struct SettingsApp: View {
    @Bindable var store: StoreOf<SettingsAppFeature>

    public var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            SettingList(
                store: store.scope(
                    state: \.settingList,
                    action: \.settingList
                )
            )
        } destination: { store in
            switch store.state {
            case .appIconSelector:
                if let store = store.scope(
                    state: \.appIconSelector,
                    action: \.appIconSelector
                ) {
                    AppIconSelector(store: store)
                        .navigationTitle("앱 아이콘")
                }
            case .openSourceList:
                if let store = store.scope(
                    state: \.openSourceList,
                    action: \.openSourceList
                ) {
                    OpenSourceList(store: store)
                        .navigationTitle("사용된 오픈소스")
                }
            }
        }
        .sheet(
            item: $store.scope(
                state: \.destination?.labs,
                action: \.destination.labs
            )
        ) { store in
            LabApp(store: store)
        }
        .sheet(
            item: $store.scope(
                state: \.destination?.subscription,
                action: \.destination.subscription
            )
        ) { store in
            SubscriptionApp(store: store)
        }
        .sheet(
            item: $store.scope(
                state: \.destination?.feedback,
                action: \.destination.feedback
            )
        ) { store in
            NavigationStack {
                FeedbackView(store: store)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("피드백 보내기")
            }
        }
        .sheet(
            item: $store.scope(
                state: \.destination?.informationWeb,
                action: \.destination.informationWeb
            )
        ) { store in
            InformationWebView(store: store)
        }
    }

    public init(store: StoreOf<SettingsAppFeature>) {
        self.store = store
    }
}

#Preview {
    SettingsApp(
        store: Store(
            initialState: SettingsAppFeature.State(),
            reducer: { SettingsAppFeature() }
        )
    )
}
