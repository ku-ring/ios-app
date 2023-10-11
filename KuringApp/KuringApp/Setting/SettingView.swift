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
        // TODO: 나중에 디펜던시로
        var currentAppIcon: KuringIcon?
        
        init(currentAppIcon: KuringIcon? = nil) {
            @Dependency(\.appIcons) var appIcons
            
            self.currentAppIcon = currentAppIcon ?? appIcons.currentAppIcon
        }
    }
    
    enum Action: Equatable {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            }
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
                        NavigationLink(
                            state: SettingsAppFeature.Path.State.appIconSelector(
                                AppIconSelectorFeature.State()
                            )
                        ) {
                            HStack {
                                Text("앱 아이콘 바꾸기")
                                
                                Spacer()
                                
                                Text(viewStore.state.currentAppIcon?.korValue ?? KuringIcon.kuring_app.korValue)
                            }
                        }
                    }
                } header: {
                    Text("정보")
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        SettingView (
            store: Store(
                initialState: SettingListFeature.State(),
                reducer: { SettingListFeature()
                }
            )
        )
    }
}
