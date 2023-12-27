//
//  SettingsApp.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/10/06.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SettingsAppFeature {
    @ObservableState
    struct State: Equatable {
        /// 스택 기반 네비게이션 Path
        var path = StackState<Path.State>()
        /// Root
        var settingList = SettingListFeature.State()
    }
    
    enum Action {
        /// 스택 기반 네비게이션 Path
        case path(StackAction<Path.State, Path.Action>)
        /// Root
        case settingList(SettingListFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.settingList, action: \.settingList) {
            SettingListFeature()
        }
    
        Reduce { state, action in
            switch action {
            case let .path(.element(id: id, action: .appIconSelector(.delegate(.completeAppIconChange)))):
                guard case let .appIconSelector(appIconSelectorState) = state.path[id: id] else {
                    return .none
                }
                state.settingList.currentAppIcon = appIconSelectorState.selectedIcon
                state.path.pop(from: id)
                return .none
                
            case .path:
                return .none
                
            case .settingList:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}

struct SettingsApp: View {
    @Bindable var store: StoreOf<SettingsAppFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            SettingView(
                store: self.store.scope(
                    state: \.settingList,
                    action: \.settingList
                )
            )
        } destination: { store in
            switch store.state {
            case .appIconSelector:
                if let store = store.scope(state: \.appIconSelector, action: \.appIconSelector) {
                    AppIconSelector(store: store)
                        .navigationTitle("앱 아이콘")
                }
            case .openSourceList:
                if let store = store.scope(state: \.openSourceList, action: \.openSourceList) {
                    OpenSourceView(store: store)
                        .navigationTitle("사용된 오픈소스")
                }
            }
        }
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
