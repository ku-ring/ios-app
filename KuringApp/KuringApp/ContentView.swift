//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import CampusUI
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
            
            CampusApp()
                .tabItem {
                    Image(systemName: "location")
                    
                    Text("캠퍼스맵")
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

