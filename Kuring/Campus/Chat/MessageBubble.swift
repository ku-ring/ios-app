//
//  MessageBubble.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringCommons
import SendbirdChatSDK

struct MessageBubble: View {
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
            text.font = .footnote
            text.foregroundColor = isSentByMe
            ? ColorSet.Background.primary.color
            : ColorSet.Label.primary.color
            if let range = text.range(of: "j_sung_0o0") {
                text[range].foregroundColor = isSentByMe
                ? ColorSet.Background.primary.color
                : ColorSet.green.color
                text[range].font = .footnote.bold()
            }
     
            return text
        } catch {
            return .init(message)
        }
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isSentByMe {
                Spacer()
                    .frame(minWidth: 130)
                
                if sendingState != .sent {
                    sendingState.icon
                }
            }
            
            VStack(alignment: isSentByMe ? .trailing : .leading, spacing: 8.0) {
                if !isSentByMe {
                    Text(username)
                        .font(.subheadline.bold())
                        .foregroundColor(ColorSet.green.color)
                }
                
                Text(attributedString)
                    .multilineTextAlignment(.leading)
                    .lineLimit(10)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSentByMe
                        ? ColorSet.green.color
                        : ColorSet.Label.primary.color.opacity(0.03)
                    )
            }
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
            
            if !isSentByMe {
                if sendingState != .sent {
                    sendingState.icon
                }
                
                Spacer()
                    .frame(minWidth: 130)
            }
        }
        .padding(.horizontal)
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

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MessageBubble(
                username: "j_sung_0o0",
                message: "테스트 메세지 입니다. 사용자와 동일한 닉네임이 있는 경우 이렇게 굵게 표시됩니다. j_sung_0o0. 그럼 계속 메세지를 전송해보세요.",
                isSentByMe: false,
                sendingState: .sent
            )
            
            MessageBubble(
                username: "j_sung_0o0",
                message: "테스트 메세지 입니다. 사용자와 동일한 닉네임이 있는 경우 이렇게 굵게 표시됩니다. j_sung_0o0. 그럼 계속 메세지를 전송해보세요.",
                isSentByMe: true,
                sendingState: .pending
            )
            
            MessageBubble(
                username: "j_sung_0o0",
                message: "테스트 메세지 입니다. 사용자와 동일한 닉네임이 있는 경우 이렇게 굵게 표시됩니다. j_sung_0o0. 그럼 계속 메세지를 전송해보세요.",
                isSentByMe: true,
                sendingState: .failed
            )
            
            MessageBubble(
                username: "j_sung_0o0",
                message: "테스트 메세지 입니다. 사용자와 동일한 닉네임이 있는 경우 이렇게 굵게 표시됩니다. j_sung_0o0. 그럼 계속 메세지를 전송해보세요.",
                isSentByMe: false,
                sendingState: .failed
            )
            
            MessageBubble(
                username: "j_sung_0o0",
                message: "테스트 메세지 입니다. 사용자와 동일한 닉네임이 있는 경우 이렇게 굵게 표시됩니다. j_sung_0o0. 그럼 계속 메세지를 전송해보세요.",
                isSentByMe: false,
                sendingState: .pending
            )
            
            MessageBubble(
                username: "j_sung_0o0",
                message: "테스트 메세지 입니다. 사용자와 동일한 닉네임이 있는 경우 이렇게 굵게 표시됩니다. j_sung_0o0. 그럼 계속 메세지를 전송해보세요.",
                isSentByMe: true,
                sendingState: .sent
            )
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
}
