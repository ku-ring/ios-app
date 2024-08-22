//
//  SwiftUIView.swift
//
//
//  Created by 최효원 on 8/6/24.
//

import SwiftUI
import ColorSet
import ComposableArchitecture

enum MessageType: Hashable {
    case question
    case answer

    var backgroundColor: Color {
        switch self {
        case .question: return Color.Kuring.gray100
        case .answer: return Color.Kuring.primarySelected
        }
    }

    var image: Image {
        switch self {
        case .question:
            return Image(systemName: "person.circle.fill")
        case .answer:
            return Image("kuring_app_circle", bundle: Bundle.bots)
        }
    }
}

struct ChatView: View {
    var messages: [Message]

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            ForEach(messages, id: \.self) { message in
                ChatRowView(message: message)
                if message.type == .answer {
                    possibleCountText(for: message.sendCount)
                }
            }
            Spacer()
        }
        .padding(.bottom, 5)
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
}

struct ChatRowView: View {
    var message: Message

    var body: some View {
        HStack(alignment: .top) {
            if message.type == .question {
                Spacer()
                messageBubble
                userImage
            } else {
                userImage
                messageBubble
                Spacer()
            }
        }
        .padding(message.type == .question ? .trailing : .leading, 16)
    }

    private var messageBubble: some View {
        let maxWidth = UIScreen.main.bounds.width * 0.7

        return Text(message.text)
            .padding()
            .background(message.type.backgroundColor)
            .cornerRadius(16)
            .frame(maxWidth: maxWidth, alignment: message.type == .question ? .trailing : .leading)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var userImage: some View {
        message.type.image
            .resizable()
            .scaledToFill()
            .frame(width: 36, height: 36)
            .clipShape(Circle())
            .foregroundStyle(Color.Kuring.gray300, Color.Kuring.gray100)
            .overlay(Circle().stroke(Color.Kuring.gray300, lineWidth: 0.1))
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

struct Message: Hashable {
    var text: String
    var type: MessageType
    var sendCount: Int
}
