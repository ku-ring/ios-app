//
//  NotificationHistoryView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/18/26.
//

import SwiftUI
import ColorSet

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
        .init(category: .academic, text: "학사경고 받기 학사일정이 있어요", daysAgo: 1, isRead: true),
        .init(category: .club, text: "릴스 시청 동아리 회원 모집", daysAgo: 2),
        .init(category: .notice, text: "등록금 고지서", daysAgo: 3, isRead: true),
        .init(category: .academic, text: "건구스한테서 도망가기 학사일정이 있어요", daysAgo: 5, isRead: true),
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
        .background(Color.Kuring.bg)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image("settings", bundle: .module)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundStyle(Color.Kuring.gray600)
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
