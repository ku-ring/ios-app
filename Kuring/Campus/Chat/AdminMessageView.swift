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
    @State private var showsMore: Bool = false
    let requestID: String
    let adminName: String = StringSet.Campus.adminName
    var prevMessage: String {
        if message.count > 255 {
            return String(message[message.index(message.startIndex, offsetBy: 0)...message.index(message.startIndex, offsetBy: 255)])
        } else {
            return message
        }
    }
    let message: String
    
    var body: some View {
        ZStack {
            ColorSet.Background.green.color
                .ignoresSafeArea(edges: .horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(adminName)
                    .font(.subheadline.bold())
                    .foregroundColor(ColorSet.Label.green.color)
                
                Group {
                    if showsMore {
                        Text(message)
                    } else {
                        Text("\(prevMessage)...")
                    }
                }
                .font(.subheadline)
                .foregroundColor(ColorSet.Label.green.color)
                .multilineTextAlignment(.leading)
                
                if message.count > 255 {
                    Button(action: showMore) {
                        Text(showsMore ? "생략하기" : "더보기")
                            .font(.subheadline)
                            .foregroundColor(ColorSet.Label.secondary.color)
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
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
    
    func showMore() {
        showsMore.toggle()
    }
}
