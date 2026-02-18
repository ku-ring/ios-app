//
//  NotificationHistoryView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/18/26.
//

import SwiftUI

struct NotificationItem: Identifiable, Equatable {
    let id = UUID()
    let category: Category
    let text: String
    let daysAgo: Int
    var isRead: Bool = false
}

enum Category: String {
    case academic = "학사일정"
    case club = "동아리"
    case notice = "공지사항"
    
    var icon: String {
        switch self {
        case .academic: return "calendar"
        case .club: return "users"
        case .notice: return "list"
        }
    }
}

public struct NotificationHistoryView: View {
    @State private var alerts: [NotificationItem] = [
        .init(category: .academic, text: "AlertText", daysAgo: 1, isRead: true),
        .init(category: .club, text: "AlertText", daysAgo: 2),
        .init(category: .notice, text: "AlertText", daysAgo: 3, isRead: true),
        .init(category: .academic, text: "AlertText", daysAgo: 5, isRead: true),
        .init(category: .club, text: "AlertText", daysAgo: 7, isRead: true)
    ]
    
    public init() { }
    
    public var body: some View {
        List {
            ForEach(alerts) { item in
                NotificationHistoryRow(item: item)
                    .listRowInsets(.init())
                    .listRowSeparator(.visible)
                    .alignmentGuide(.listRowSeparatorLeading) { _ in
                        return 0
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            delete(item)
                        } label: {
                            Text("삭제")
                        }
                    }
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image("settings", bundle: .module)
                    .resizable()
                    .frame(width: 26, height: 26)
            }
        }
    }
    
    private func delete(_ item: NotificationItem) {
        withAnimation(.snappy) {
            alerts.removeAll { $0.id == item.id }
        }
    }
}

#Preview {
    NotificationHistoryView()
}
