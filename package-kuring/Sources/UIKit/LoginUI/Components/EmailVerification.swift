//
//  EmailVerification.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/9/25.
//

import SwiftUI
import ColorSet
import LoginFeatures
import ComposableArchitecture

/// 비밀번호 찾기/회원가입에서 사용되는 이메일 인증
/// ```swift
///   EmailVerification(canProceed: $canProceed)
/// ```
///  - Parameters:
///    - canProceed: 인증이 완료되어서 다음 화면으로 넘어갈수 있을지 나타내는 부울값
struct EmailVerification: View {
    @Bindable var store: StoreOf<EmailVerificationFeature>
    
    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 4) {
                HStack {
                    emailTextField
                    verificationButton
                }
                
                if !store.isValidEmail {
                    LoginErrorMessage(message: "등록되지 않은 이메일이에요.")
                }
            }
            
            VStack(spacing: 4) {
                verificationTextField
                
                if !store.verificationCode.isEmpty && !store.isValidVerificationCode {
                    LoginErrorMessage(message: "올바르지 않은 인증번호에요.")
                }
            }
        }
        .onDisappear {
            store.send(.stopTimer)
        }
    }
    
    private var emailTextField: some View {
        EmailTextField(
            email: $store.email,
            placeholder: "학교 이메일 주소"
        )
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.Kuring.gray100)
                .stroke(Color.Kuring.warning, lineWidth: store.isValidEmail ? 0 : 1)
        )
    }
    
    private var verificationButton: some View {
        Button {
            store.send(.verificationButtonTapped)
        } label: {
            Text(store.verificationState.buttonText)
                .foregroundStyle(store.verificationState.textColor)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 114, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(store.verificationState.backgroundColor)
                        .stroke(store.verificationState.borderColor, lineWidth: 1)
                )
        }
        .disabled(!store.verificationState.isEnabled)
    }
    
    private var verificationTextField: some View {
        HStack {
            TextField(
                "",
                text: $store.verificationCode,
                prompt: Text("인증번호 입력").foregroundStyle(Color.Kuring.caption1)
            )
            .keyboardType(.numberPad)
            
            Text("\(timeString(from: store.timeRemaining))")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.Kuring.warning)
        }
        .frame(height: 50)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.Kuring.gray100)
                .stroke(
                    store.verificationCodeBorderColor,
                    lineWidth: store.verificationCode.isEmpty ? 0 : 1
                )
        )
    }
}

extension EmailVerification {
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
