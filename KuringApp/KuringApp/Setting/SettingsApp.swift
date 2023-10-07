//
//  SettingsApp.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/10/06.
//

import SwiftUI
import ComposableArchitecture

struct SettingsAppFeature: Reducer {
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
        Scope(state: \.settingList, action: /Action.settingList) {
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
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}

struct SettingsApp: View {
    let store: StoreOf<SettingsAppFeature>
    
    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) })) {
            SettingView(
                store: self.store.scope(
                    state: \.settingList,
                    action: { .settingList($0) }
                )
            )
        } destination: { state in
            switch state {
            case .appIconSelector:
                CaseLet(
                    /SettingsAppFeature.Path.State.appIconSelector,
                     action: SettingsAppFeature.Path.Action.appIconSelector
                ) { store in
                    AppIconSelector(store: store)
                        .navigationTitle("앱 아이콘")
                }
            }
        }

    }
}

#Preview {
    NavigationStack {
        SettingsApp(
            store: Store(
                initialState: SettingsAppFeature.State(),
                reducer: { SettingsAppFeature() }
            )
        )
        .navigationTitle("더보기")
        .navigationBarTitleDisplayMode(.inline)
    }
}
