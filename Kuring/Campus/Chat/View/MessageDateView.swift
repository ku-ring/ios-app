//
//  MessageDateView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/14.
//

import SwiftUI
import KuringCommons
import SendbirdChatSDK

struct MessageDateView: View {
    let date: Date
    
    var body: some View {
        Text(date, style: .date)
            .font(.caption)
            .foregroundColor(ColorSet.Label.tertiary.color)
            .padding(.vertical, 2)
            .padding(.horizontal, 8)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(ColorSet.Label.tertiary.color, lineWidth: 1)
            }
            .padding(.vertical, 8)
    }
    
    init(message: BaseMessage) {
        
        let sentAt = Double(message.updatedAt != 0 ? message.updatedAt : message.createdAt)
        self.date = Date(timeIntervalSince1970: sentAt / 1000)
    }
}
