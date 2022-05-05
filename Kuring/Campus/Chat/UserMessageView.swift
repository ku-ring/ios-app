//
//  UserMessageView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/06.
//

import SwiftUI
import KuringCommons
import SendbirdChatSDK

struct UserMessageView: View {
    @ObservedObject var viewModel: KuringChatViewModel
    
    let requestID: String
    let username: String
    let message: String
    let isSentByMe: Bool
    let sendingState: SendingState
    
    enum SendingState {
        case sent
        case failed
        case pending
        
        var icon: some View {
            switch self {
            case .sent:
                return Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .clipped()
                    .foregroundColor(ColorSet.green.color)
            case .failed:
                return Image(systemName: "exclamationmark.circle")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .clipped()
                    .foregroundColor(ColorSet.pink.color)
            case .pending:
                return Image(systemName: "circle.dotted")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .clipped()
                    .foregroundColor(ColorSet.secondaryGray.color)
            }
        }
    }
    
    // Move to extension?
    var attributedString: AttributedString {
        do {
            var text = try AttributedString(markdown: message)
            text.font = .subheadline
            text.foregroundColor = ColorSet.Label.primary.color
            if let myUsername = SendbirdChat.getCurrentUser()?.nickname, let range = text.range(of: myUsername) {
                text[range].foregroundColor = isSentByMe
                ? ColorSet.Label.primary.color
                : ColorSet.green.color
                text[range].font = .subheadline.bold()
            }
     
            return text
        } catch {
            return .init(message)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("@\(username)")
                    .font(.subheadline.bold())
                    .foregroundColor(
                        isSentByMe
                        ? ColorSet.green.color
                        : ColorSet.Label.secondary.color
                    )
                
                Text("10:56 PM")
                    .font(.footnote)
                    .foregroundColor(ColorSet.Label.tertiary.color)
                
                Spacer()
            }
            
            Text(attributedString)
                .multilineTextAlignment(.leading)
            
            if sendingState != .sent {
                sendingState.icon
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .contextMenu {
            if sendingState == .sent {
                Button(action: copy) {
                    Label("복사하기", systemImage: "doc.on.doc")
                }
            } else {
                Button(action: { viewModel.resendUserMessage(requestID: requestID) }) {
                    Label("재전송하기", systemImage: "paperplane")
                }
                
                Button(action: { viewModel.deleteNotSentMessage(requestID: requestID) }) {
                    Label("취소하기", systemImage: "trash")
                }
            }
        }
        .id(requestID)
    }
    
    init(viewModel: KuringChatViewModel = .init(), username: String, message: String, isSentByMe: Bool, sendingState: SendingState) {
        self.viewModel = viewModel
        self.requestID = ""
        self.username = username
        self.message = message
        self.isSentByMe = isSentByMe
        self.sendingState = sendingState
    }
    
    init(viewModel: KuringChatViewModel, userMessage: UserMessage) {
        self.viewModel = viewModel
        self.requestID = userMessage.requestID
        self.username = userMessage.sender?.nickname ?? "(알 수 없음)"
        self.message = userMessage.message
        self.isSentByMe = userMessage.sender?.userID == KuringCampus.userID
        switch userMessage.sendingStatus {
        case .succeeded:
            self.sendingState = .sent
        case .failed:
            self.sendingState = .failed
        case .pending:
            self.sendingState = .pending
        default:
            self.sendingState = .sent
        }
    }
    
    func copy() {
        UIPasteboard.general.string = message
    }
}
