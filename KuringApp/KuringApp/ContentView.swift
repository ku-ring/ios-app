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
import AcademicCalendarUI
import ComposableArchitecture

struct ContentView: View {
    @State var activeTab: TabBarItem = .notice
    // 앱 최초 구동 시점에 1회 공지를 가져오기 위함
    @Binding var didAppear: Bool
    
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

    init(didAppear: Binding<Bool>) {
        self._didAppear = didAppear
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch activeTab {
                case .notice:
                    NoticeApp(store: noticeStore)
                case .calendar:
                    AcademicCalendar()
                case .campusMap:
                    CampusApp()
                case .settings:
                    SettingsApp(store: settingsStore)
                }
            }
            .tint(Color.Kuring.gray600)
            .background(Color.Kuring.bg)
            .environment(\.horizontalSizeClass, .compact)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: activeTab) { oldValue, newValue in
                if oldValue != newValue && newValue == .notice {
                    noticeStore.send(.noticeList(.reloadNotices))
                }
            }
            .onAppear {
                if !didAppear {
                    noticeStore.send(.noticeList(.reloadNotices))
                    didAppear = true
                }
            }
            
            BottomTabView(activeTab: $activeTab)
        }
    }
}


