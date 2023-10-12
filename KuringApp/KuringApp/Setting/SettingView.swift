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
            List {
                Section {
                    Label("공지 구독하기", systemImage: "bell")
                    
                    Label("기타 알림 받기", systemImage: "bell")
                } header: {
                    Text("공지구독")
                }
                
                Section {
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
                } header: {
                    Text("정보")
                }
                
                Section {
                    
                } header: {
                    Text("SNS")
                }
                
                Section {
                    
                } header: {
                    Text("피드백")
                }
            }
            .navigationTitle("더보기")
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
