//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import SwiftUI
import ClubsUI
import CampusUI
import NoticeUI
import SettingsUI
import Dependencies
import ClubsFeatures
import NoticeFeatures
import SettingsFeatures
import PushNotifications
import AcademicCalendarUI
import ComposableArchitecture
import AcademicCalendarFeatures

struct ContentView: View {
    @Dependency(\.activeTab) var activeTab
    @Bindable private var tabStore: ActiveTabStore

    // 앱 최초 구동 시점에 1회 공지를 가져오기 위함
    @Binding var didAppear: Bool

    @State private var noticeStore = Store(
      initialState: NoticeAppFeature.State(noticeList: NoticeListFeature.State()),
      reducer: { NoticeAppFeature()._printChanges() }
    )

    @State private var calendarStore = Store(
      initialState: AcademicCalendarFeature.State(),
      reducer: { AcademicCalendarFeature() }
    )

    @State private var settingsStore = Store(
      initialState: SettingsAppFeature.State(),
      reducer: { SettingsAppFeature() }
    )

    @State private var clubsStore: StoreOf<ClubsAppFeature> = Store(
        initialState: ClubsAppFeature.State(),
        reducer: { ClubsAppFeature() }
    )

    init(didAppear: Binding<Bool>) {
        self._didAppear = didAppear
        self.tabStore = ActiveTabDependency.liveValue.store
    }

    var body: some View {
        TabView(selection: $tabStore.value) {
            NoticeApp(store: noticeStore)
                .tabItem { tabLabel(for: .notice) }
                .tag(TabBarItem.notice)

            AcademicCalendar(store: calendarStore)
                .tabItem { tabLabel(for: .calendar) }
                .tag(TabBarItem.calendar)

            CampusApp()
                .tabItem { tabLabel(for: .campusMap) }
                .tag(TabBarItem.campusMap)

            ClubsApp(store: clubsStore)
                .tabItem { tabLabel(for: .clubs) }
                .tag(TabBarItem.clubs)

            SettingsApp(store: settingsStore)
                .tabItem { tabLabel(for: .settings) }
                .tag(TabBarItem.settings)
        }
        .tint(Color.Kuring.gray600)
        .background(Color.Kuring.bg)
        .environment(\.horizontalSizeClass, .compact)
        .onChange(of: tabStore.value) { oldValue, newValue in
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
        // MARK: 학사일정 푸시 알림을 탭 했을 때 호출
        .onReceive(newMessagePublisher) { message in
            switch message {
            case .academic:
                @Dependency(\.activeTab) var activeTab
                activeTab.store.value = .calendar
                calendarStore.send(.selectDate(Date()))
            // FIXME: 학사일정 type 서버에서 구현후 default 부분 삭제 (2025/11/02)
            case let .default(_, body) where body.contains("오늘부터") || body.contains("오늘은"):
                @Dependency(\.activeTab) var activeTab
                activeTab.store.value = .calendar
                calendarStore.send(.selectDate(Date()))
            default:
                return
            }
        }
    }

    @ViewBuilder
    private func tabLabel(for tab: TabBarItem) -> some View {
        Label {
            Text(tab.title)
        } icon: {
            Image(tabStore.value == tab ? tab.selectedImage : tab.defaultImage)
        }
    }
}

extension TabBarItem {
    var selectedImage: ImageResource {
        switch self {
        case .notice:
            return .listFill
        case .calendar:
            return .calendarFill
        case .campusMap:
            return .mapPinFill
        case .clubs:
            return .clubsFill
        case .settings:
            return .moreHorizontalFill
        }
    }

    var defaultImage: ImageResource {
        switch self {
        case .notice:
            return .list
        case .calendar:
            return .calendar
        case .campusMap:
            return .mapPin
        case .clubs:
            return .clubs
        case .settings:
            return .moreHorizontal
        }
    }
}
