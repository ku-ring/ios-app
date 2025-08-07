//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import ColorSet
import CampusUI
import NoticeUI
import BookmarkUI
import SettingsUI
import NoticeFeatures
import BookmarkFeatures
import SettingsFeatures
import ComposableArchitecture

struct ContentView: View {
    @State private var selection: TabBarItem = .notice
    
    @State private var noticeStore = Store(
      initialState: NoticeAppFeature.State(noticeList: NoticeListFeature.State()),
      reducer: { NoticeAppFeature()._printChanges() }
    )
    
    @State private var bookmarkStore = Store(
      initialState: BookmarkAppFeature.State(bookmarkList: BookmarkListFeature.State()),
      reducer: { BookmarkAppFeature() }
    )
    
    @State private var settingsStore = Store(
      initialState: SettingsAppFeature.State(),
      reducer: { SettingsAppFeature() }
    )
     
    enum TabBarItem: Hashable {
        case notice
        case archive
        case campusMap
        case settings
    }
    
    init() {
        UITabBar.appearance().barTintColor = UIColor.init(Color.Kuring.bg)
    }
    
    var body: some View {
        TabView(selection: $selection) {
            NoticeApp(
                store: noticeStore
            )
            .tag(TabBarItem.notice)
            .tabItem {
                Image(selection == .notice ? .listFill : .list)
                
                Text("공지사항")
            }
            
            BookmarkApp(
                store: bookmarkStore
            )
            .tag(TabBarItem.archive)
            .tabItem {
                Image(selection == .archive ? .archiveFill : .archive)
                
                Text("공지보관함")
            }
            
            CampusApp()
                .tag(TabBarItem.campusMap)
                .tabItem {
                    Image(selection == .campusMap ? .mapPinFill : .mapPin)
                    
                    Text("캠퍼스맵")
                }
            
            SettingsApp(
                store: settingsStore
            )
            .tag(TabBarItem.settings)
            .tabItem {
                Image(selection == .settings ? .moreHorizontalFill : .moreHorizontal)
                
                Text("더보기")
            }
        }
        .tint(Color.Kuring.gray600)
        
    }
}

#Preview {
    ContentView()
}

