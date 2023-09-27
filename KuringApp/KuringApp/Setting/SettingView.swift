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
        var currentAppIcon: String?
    }
    
    enum Action: Equatable {
        case appIconChangeButtonTapped
        case changeIcon(PresentationAction<AppIconSelect.Action>)
        
        // MARK: Toolbar Action
        case save
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .appIconChangeButtonTapped:
                state.selectAppIcon = AppIconSelect.State(
                    selectedIcon: state.currentAppIcon ?? "kuring.app.classic"
                )
                return .none
                
            case let .changeIcon(.presented(.delegate(action))):
                switch action {
                case let .appIconChanged(app):
                    state.currentAppIcon = app
                    return .none
                }
                
            case .save:
                UIApplication.shared.setAlternateIconName(state.currentAppIcon) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("setting done")
                    }
                }
                state.selectAppIcon = nil
                return .none
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
                            viewStore.send(.appIconChangeButtonTapped)
                        } label: {
                            HStack {
                                Text("앱 아이콘 바꾸기")
                                Spacer()
                                Text(viewStore.state.currentAppIcon ?? "kuring.app.classic")
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
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    viewStore.send(.save)
                                } label: {
                                    Text("저장")
                                }
                            }
                        }
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
