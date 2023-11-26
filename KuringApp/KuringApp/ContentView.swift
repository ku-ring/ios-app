//
//  ContentView.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/13.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    var body: some View {
        TabView {
            NoticeAppView(
                store: Store(
                    initialState: NoticeAppFeature.State(
                        noticeList: NoticeListFeature.State()
                    ),
                    reducer: { NoticeAppFeature() }
                )
            )
            .tabItem {
                Image(systemName: "list.dash")
                
                Text("공지사항")
            }
            
            SettingsApp(
                store: Store(
                    initialState: SettingsAppFeature.State(),
                    reducer: { SettingsAppFeature() }
                )
            )
            .tabItem {
                Image(systemName: "ellipsis")
                
                Text("더보기")
            }
        }
    }
}

#Preview {
    ContentView()
}

