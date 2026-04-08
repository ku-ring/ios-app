//
//  BottomTabView.swift
//  KuringApp
//
//  Created by Jung Hwan Park on 9/15/25.
//

import Caches
import SwiftUI
import Dependencies

struct BottomTabView: View {
    @Bindable var activeTab: ActiveTabStore
    
    @Environment(\.colorScheme) private var colorScheme
    private var tabForegroundColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        HStack(alignment: .center) {
            ForEach(TabBarItem.allCases, id: \.title) { tab in
                tabView(tabItem: tab)
                    .onTapGesture {
                        activeTab.value = tab
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 49)
        .ignoresSafeArea(edges: .bottom)
        .background(
            Color.Kuring.gray100
        )
        .overlay(alignment: .top) {
            Divider()
        }
    }
    
    @ViewBuilder
    private func tabView(tabItem: TabBarItem) -> some View {
        VStack {
            Image(activeTab.value == tabItem ? tabItem.selectedImage : tabItem.defaultImage)
                .frame(height: 28)
            
            Text(tabItem.title)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(activeTab.value == tabItem ? tabForegroundColor : .gray)
        }
        .frame(maxWidth: .infinity)
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
