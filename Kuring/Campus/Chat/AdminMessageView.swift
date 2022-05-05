//
//  AdminMessageView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringCommons
import SendbirdChatSDK

struct AdminMessageView: View {
    let requestID: String
    let adminName: String = StringSet.Campus.adminName
    let message: String
    
    var body: some View {
        ZStack {
            ColorSet.Background.green.color
                .ignoresSafeArea(edges: .horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(adminName)
                    .font(.subheadline.bold())
                    .foregroundColor(ColorSet.Label.green.color)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(ColorSet.Label.green.color)
                    .multilineTextAlignment(.leading)
                    .lineLimit(10)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
        }
        .contextMenu {
            Button(action: share) {
                Label("공유하기", systemImage: "doc.on.doc")
            }
        }
        .id(requestID)
    }
    
    init(adminMessage:AdminMessage) {
        self.requestID = "\(adminMessage.messageID)"
        self.message = adminMessage.message
    }
    
    func share() {
        UIPasteboard.general.string = message
    }
}
