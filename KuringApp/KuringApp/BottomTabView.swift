//
//  BottomTabView.swift
//  KuringApp
//
//  Created by Jung Hwan Park on 9/15/25.
//

import SwiftUI

enum TabBarItem: Hashable, CaseIterable {
    case notice
    case calendar
    case campusMap
    case settings
    
    var title: String {
        switch self {
        case .notice:
            return "공지사항"
        case .calendar:
            return "학사일정"
        case .campusMap:
            return "캠퍼스맵"
        case .settings:
            return "더보기"
        }
    }
    
    var selectedImage: ImageResource {
        switch self {
        case .notice:
            return .listFill
        case .calendar:
            return .calendarFill
        case .campusMap:
            return .mapPinFill
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
        case .settings:
            return .moreHorizontal
        }
    }
}

struct BottomTabView: View {
    @Binding var activeTab: TabBarItem
    
    @Environment(\.colorScheme) private var colorScheme
    private var tabForegroundColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        HStack(alignment: .center) {
            ForEach(TabBarItem.allCases, id: \.title) { tab in
                tabView(tabItem: tab)
                    .onTapGesture {
                        activeTab = tab
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
            Image(activeTab == tabItem ? tabItem.selectedImage : tabItem.defaultImage)
                .frame(height: 28)
            
            Text(tabItem.title)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(activeTab == tabItem ? tabForegroundColor : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}
