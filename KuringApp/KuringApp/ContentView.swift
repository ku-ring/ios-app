//
//  ContentView.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/13.
//

import SwiftUI
import NoticeUI
import BookmarkUI
import SettingsUI
import NoticeFeatures
import BookmarkFeatures
import SettingsFeatures
import ComposableArchitecture

struct ContentView: View {
    var body: some View {
        TabView {
            NoticeApp(
                store: Store(
                    initialState: NoticeAppFeature.State(
                        noticeList: NoticeListFeature.State()
                    ),
                    reducer: { NoticeAppFeature()._printChanges() }
                )
            )
            .tabItem {
                Image(systemName: "list.dash")
                
                Text("공지사항")
            }
            
            BookmarkApp(
                store: Store(
                    initialState: BookmarkAppFeature.State(
                        bookmarkList: BookmarkListFeature.State()
                    ),
                    reducer: { BookmarkAppFeature() }
                )
            )
            .tabItem {
                Image(systemName: "archivebox")
                
                Text("공지보관함")
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

