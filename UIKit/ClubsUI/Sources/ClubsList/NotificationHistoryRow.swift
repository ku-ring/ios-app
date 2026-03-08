//
//  NotificationHistoryRow.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/18/26.
//

import Models
import SwiftUI
import ColorSet

struct NotificationHistoryRow: View {
    let notification: NotificationHistoryEntity
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 2) {
                Image(Category(rawValue: notification.type)?.icon ?? "users", bundle: .module)
                    .resizable()
                    .frame(width: 14, height: 14)
                
                Text(Category(rawValue: notification.type)?.title ?? "공지사항")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.Kuring.caption1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Text(notification.body)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.Kuring.body)
                
                Spacer()
                
                Text("\(notification.timeAgo())")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.Kuring.caption1)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(!notification.isRead ? Color.Kuring.bg : Color.Kuring.primarySelected)
        .contentShape(Rectangle())
    }
    
    private enum Category: String {
        case academic
        case club
        case notice
        
        public var icon: String {
            switch self {
            case .academic: return "calendar"
            case .club: return "users"
            case .notice: return "list"
            }
        }
        
        public var title: String {
            switch self {
            case .academic:
                return "학사일정"
            case .club:
                return "동아리"
            case .notice:
                return "공지사항"
            }
        }
    }
}
