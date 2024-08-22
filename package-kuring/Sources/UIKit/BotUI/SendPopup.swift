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
            .padding([.horizontal, .bottom], 30)
            .padding(.top, 43)
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
        } label: {
            Text("전송하기")
                .foregroundStyle(Color.Kuring.primary)
        }
    }
}
