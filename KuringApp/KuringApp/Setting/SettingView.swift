//
//  SettingView.swift
//  KuringApp
//
//  Created by 박성수 on 2023/09/27.
//

import SwiftUI
import ComposableArchitecture

struct SettingListFeature: Reducer {
    struct State: Equatable {
        @PresentationState var selectAppIcon: AppIconSelect.State?
        var currentAppIcon: KuringIcon?
    }
    
    enum Action: Equatable {
        case appIconPresentButtonTapped
        case changeIcon(PresentationAction<AppIconSelect.Action>)
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .appIconPresentButtonTapped:
                state.selectAppIcon = AppIconSelect.State(
                    selectedIcon: state.currentAppIcon ?? KuringIcon.kuring_app
                )
                return .none
                
            case let .changeIcon(.presented(.delegate(action))):
                switch action {
                case let .alternativeAppIconSave(icon):
                    state.currentAppIcon = icon
                    state.selectAppIcon = nil
                    return .none
                }
                
            default:
                return .none
            }
        }
        .ifLet(\.$selectAppIcon, action: /Action.changeIcon) {
            AppIconSelect()
        }
    }
}

struct SettingView: View {
    let store: StoreOf<SettingListFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    List {
                        Button {
                            viewStore.send(.appIconPresentButtonTapped)
                        } label: {
                            HStack {
                                Text("앱 아이콘 바꾸기")
                                Spacer()
                                Text(viewStore.state.currentAppIcon?.korValue ?? KuringIcon.kuring_app.korValue)
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                } header: {
                    Text("정보")
                }
            }
            .sheet(
                store: self.store.scope(
                    state: \.$selectAppIcon,
                    action: { .changeIcon($0) }
                )
            ) { store in
                NavigationStack {
                    AppIconSelectView(store: store)
                        .navigationTitle("App Icon select Page")
                }
                
            }
            
        }
    }
}


#Preview {
    SettingView (
        store: Store(
            initialState: SettingListFeature.State(),
            reducer: { SettingListFeature()
            }
        )
    )
}
