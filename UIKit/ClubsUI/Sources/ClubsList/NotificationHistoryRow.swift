//
//  NotificationHistoryRow.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/18/26.
//

import SwiftUI
import ColorSet

struct NotificationHistoryRow: View {
    let item: NotificationItem
    
    var body: some View {
        VStack(spacing: 8) {
            
            HStack(spacing: 2) {
                Image(item.category.icon, bundle: .module)
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundStyle(Color.Kuring.caption1)
                
                Text(item.category.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.Kuring.caption1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            

            HStack {
                Text(item.text)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.Kuring.body)
                
                Spacer()
                
                Text("\(item.daysAgo)일 전")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.Kuring.caption1)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(item.isRead ? Color.Kuring.bg : Color.Kuring.primarySelected)
        .contentShape(Rectangle())
    }
}
