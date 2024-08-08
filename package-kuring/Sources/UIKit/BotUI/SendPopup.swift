//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import ComposableArchitecture
import ColorSet
import Networks
import Dependencies

struct SendPopup: View {
    @Binding var isVisible: Bool
    var onSendAction: () -> Void
    @Dependency(\.kuringLink) private var kuringLink
    
    var fcmToken: String = ""
    
    @StateObject private var sseClient = SSEClient(content: "교내,외 장학금 및 학자금 대출 관련 전화번호들을 안내를 해줘", temp: 0.7)

    
    
    var body: some View {
        ZStack {
            if isVisible {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack(spacing: 0) {
                confirmationMessage
                actionButtons
            }
            .background(Color.Kuring.bg)
            .cornerRadius(15)
            .padding(.horizontal, 45)
            .frame(maxHeight: .infinity)
            .font(.system(size: 16, weight: .medium))
        }
    }
    
    private var confirmationMessage: some View {
        Text("전송하시면 횟수 차감이 인정돼요.\n전송할까요?")
            .foregroundStyle(Color.Kuring.body)
            .multilineTextAlignment(.center)
            .padding(40)
            .padding(.bottom, 0)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(alignment: .center) {
                cancelButton
                Divider().padding(.horizontal, 40)
                sendButton
            }
            .frame(height: 55)
        }
    }
    
    private var cancelButton: some View {
        Button {
            isVisible = false
        } label: {
            Text("취소하기")
                .foregroundStyle(Color.Kuring.body)
        }
    }
    
    private var sendButton: some View {
        Button {
            isVisible = false
            onSendAction()
            sseClient.start()
            
            if let error = sseClient.error {
                           print("Error: \(error.localizedDescription)")
                       }
            
        } label: {
            Text("전송하기")
                .foregroundStyle(Color.Kuring.primary)
        }
    }
}
