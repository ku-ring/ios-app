//
//  UserMessageView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringSDK
import KuringCommons
import SendbirdChatSDK

struct UserMessageView: View {
    @ObservedObject var viewModel: ChatViewModel
    @StateObject private var webViewModel = WebViewModel()
    @State private var showsNoticeWebView: Bool = false
    
    let messageID: String
    let requestID: String
    let username: String
    let message: String
    let sentAt: Date
    let isSentByMe: Bool
    let sendingState: SendingState
    
    struct NoticeInfo {
        let subject: String
        let url: String
    }
    var noticeInfo: NoticeInfo?
    
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
            if let myUsername = SendbirdChat.getCurrentUser()?.nickname, let range = text.range(of: myUsername) {
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
                
                if sendingState != .sent {
                    sendingState.icon
                        .padding(.leading, 64)
                } else {
                    Text(sentAt, style: .time)
                        .font(.caption)
                        .foregroundColor(ColorSet.Label.tertiary.color)
                        .padding(.leading, 64)
                }
            }
            
            VStack(alignment: .leading) {
                if !isSentByMe {
                    Text(username)
                        .font(.subheadline.bold())
                        .foregroundColor(ColorSet.green.color)
                }
                
                if let noticeInfo = noticeInfo {
                    Label(noticeInfo.subject, systemImage: "megaphone.fill")
                        .font(.footnote.bold())
                        .foregroundColor(
                            isSentByMe
                            ? ColorSet.Background.primary.color
                            : ColorSet.Label.primary.color
                        )
                        .onTapGesture {
                            showsNoticeWebView = true
                        }
                }
                
                Text(attributedString)
                    .multilineTextAlignment(.leading)
                    .lineLimit(10)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background {
                RoundedRectangle(cornerRadius: 12)
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
                        .padding(.trailing, 64)
                } else {
                    Text(sentAt, style: .time)
                        .font(.caption)
                        .foregroundColor(ColorSet.Label.tertiary.color)
                        .padding(.trailing, 64)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal)
        .id(messageID == "0" ? requestID : messageID)
        .sheet(isPresented: $showsNoticeWebView) {
            NavigationView {
                ZStack {
                    WebView(viewModel: webViewModel, urlString: noticeInfo!.url)
                    
                    if webViewModel.isLoading {
                        LottieView(filename: StringSet.Lottie.loading)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Image("appIconLabel")
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showsNoticeWebView = false
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(ColorSet.primary.color)
                        }
                        
                    }
                }
            }
        }
    }
    
    init(viewModel: ChatViewModel, userMessage: UserMessage) {
        self.viewModel = viewModel
        self.requestID = userMessage.requestID
        self.messageID = "\(userMessage.messageID)"
        self.username = userMessage.sender?.nickname ?? "(알 수 없음)"
        self.message = userMessage.message
        self.sentAt = Date(
            timeIntervalSince1970: userMessage.updatedAt != 0
            ? Double(userMessage.updatedAt) / 1000
            : Double(userMessage.createdAt) / 1000
        )
        self.isSentByMe = userMessage.sender?.userID == Kuring.userID
        
        if let data = userMessage.data.data(using: .utf8) {
            let decoder = JSONDecoder()
            if let noticeInfo = try? decoder.decode([String: String].self, from: data) {
                self.noticeInfo = NoticeInfo(
                    subject: noticeInfo[StringSet.Campus.MessagePayloadKey.noticeSubject] ?? "",
                    url: noticeInfo[StringSet.Campus.MessagePayloadKey.noticeURL] ?? ""
                )
            }
        }
        
        
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
