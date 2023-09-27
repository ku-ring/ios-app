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
                        noticeList: NoticeListFeature.State(notices: [.random])
                    ),
                    reducer: { NoticeAppFeature() }
                )
            )
            .tabItem {
                Image(systemName: "list.dash")
                
                Text("공지사항")
            }
        }
    }
}

#Preview {
    ContentView()
}

