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
    @State var activeTab: TabBarItem = .notice
    
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
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch activeTab {
                case .notice:
                    NoticeApp(store: noticeStore)
                case .archive:
                    BookmarkApp(store: bookmarkStore)
                case .campusMap:
                    CampusApp()
                case .settings:
                    SettingsApp(store: settingsStore)
                }
            }
            .tint(Color.Kuring.gray600)
            .background(Color.Kuring.bg)
            .animation(.default, value: activeTab)
            .environment(\.horizontalSizeClass, .compact)
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            BottomTabView(activeTab: $activeTab)
        }
    }
}


