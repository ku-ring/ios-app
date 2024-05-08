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
    @State private var selection: TabBarItem = .notice
    
    enum TabBarItem: Hashable {
        case notice
        case archive
        case campusMap
        case settings
    }
    
    var body: some View {
        TabView(selection: $selection) {
            NoticeApp(
                store: Store(
                    initialState: NoticeAppFeature.State(
                        noticeList: NoticeListFeature.State()
                    ),
                    reducer: { NoticeAppFeature()._printChanges() }
                )
            )
            .tabItem {
                Image(selection == .notice ? .listFill : .list)
                
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
                Image(selection == .archive ? .archiveFill : .archive)
                
                Text("공지보관함")
            }
            
            CampusApp()
                .tabItem {
                    Image(selection == .campusMap ? .mapPinFill : .mapPin)
                    
                    Text("캠퍼스맵")
                }
            
            SettingsApp(
                store: Store(
                    initialState: SettingsAppFeature.State(),
                    reducer: { SettingsAppFeature() }
                )
            )
            .tabItem {
                Image(selection == .settings ? .moreHorizontalFill : .moreHorizontal)
                
                Text("더보기")
            }
        }
        .tint(Color.black)
        .onChange(of: selection) { _ , newValue in
            print("🌱 newValue \(newValue)")
            selection = newValue
        }
    }
}

#Preview {
    ContentView()
}

