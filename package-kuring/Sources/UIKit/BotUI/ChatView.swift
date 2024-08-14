//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import ColorSet
import ComposableArchitecture
import Lottie
import BotFeatures
import Models
import Caches
import SwiftData

struct ChatView: View {
    @Bindable var store: StoreOf<BotFeature>
    @Query(FetchDescriptor<ChatInfo>()) var chatQuery: [ChatInfo]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                ForEach(store.chatHistory) { chat in
                    HStack(alignment: .top) {
                        if chat.type == .question {
                            Spacer()
                            messageBubble(for: chat)
                            userImage(for: chat.type)
                        } else {
                            userImage(for: chat.type)
                            chatStatusView(for: chat)
                            Spacer()
                        }
                    }
                    .padding(chat.type == .question ? .trailing : .leading, 16)
                    if chat.type == .answer {
                        possibleCountText(for: 2 - (chat.index / 2))
                    }
                }
                Spacer()
            }
            .padding(.bottom, 5)
            
        }
        /// query 변경 감지
        .onChange(of: self.chatQuery, initial: true) {_, newValue in
            store.send(.queryChanged(newValue))
        }
    }
    
    @ViewBuilder
    private func chatStatusView(for message: ChatInfo) -> some View {
        switch message.chatStatus {
        case .waiting:
            lottieView
        case .complete:
            messageBubble(for: message)
        default:
            lottieView
        }
    }
    
    private var lottieView: some View {
        LottieView(animation: .named("animation_loading.json", bundle: Bundle.bots))
            .playing()
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
    }
    
    private func messageBubble(for message: ChatInfo) -> some View {
        let maxWidth = UIScreen.main.bounds.width * 0.7
        
        return Text(message.text)
            .padding()
            .background(message.type == .question
                        ? Color.Kuring.gray100 : Color.Kuring.primarySelected)
            .cornerRadius(16)
            .frame(maxWidth: maxWidth, alignment: message.type == .question ? .trailing : .leading)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    private func userImage(for messageType: ChatInfo.MessageType) -> some View {
        let image: Image = messageType == .question
        ? Image(systemName: "person.circle.fill") : Image("kuring_app_circle", bundle: Bundle.bots)
        
        return image
            .resizable()
            .scaledToFill()
            .frame(width: 36, height: 36)
            .clipShape(Circle())
            .foregroundStyle(Color.Kuring.gray300, Color.Kuring.gray100)
            .overlay(Circle().stroke(Color.Kuring.gray300, lineWidth: 0.1))
    }
    
    private func possibleCountText(for sendCount: Int) -> some View {
        let currentDate = formattedCurrentDate()
        return Text("질문 가능 횟수 \(sendCount)회 (\(currentDate) 기준)")
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(sendCount == 0 ? Color.Kuring.warning : Color.Kuring.caption1)
    }
    
    private func formattedCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: Date())
    }
    
    public init(store: StoreOf<BotFeature>) {
        self.store = store
    }
}

struct ChatEmptyView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("kuring_app_gray", bundle: Bundle.bots)
            Spacer().frame(height: 20)
            Text("궁금한 건국대학교의\n공지 내용을 질문해보세요")
                .foregroundStyle(Color.Kuring.caption1)
                .font(.system(size: 15, weight: .medium))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
            Spacer()
        }
    }
}
