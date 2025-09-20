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
///   EmailVerification(store: store, type: .signup)
///   or
///   EmailVerification(store: store, type: .findPassword)
/// ```
///  - Parameters:
///    - canProceed: 인증이 완료되어서 다음 화면으로 넘어갈수 있을지 나타내는 부울값
struct EmailVerification: View {
    @Bindable var store: StoreOf<EmailVerificationFeature>
    let type: EmailVerificationFeature.VerificationType

    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 4) {
                HStack {
                    emailTextField
                    verificationButton
                }
                
                if case .invalid = store.emailState {
                    LoginErrorMessage(message: "등록되지 않은 이메일이에요.")
                }
            }
            
            VStack(spacing: 4) {
                if store.shouldShowVerificationField {
                    verificationTextField
                }
                
                if case .invalid = store.verificationState {
                    LoginErrorMessage(message: "올바르지 않은 인증번호에요.")
                }
            }
        }
        .onChange(of: store.email) { oldValue, newValue in
            if oldValue != newValue {
                store.send(.emailChanged)
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
                .stroke(emailBorderColor, lineWidth: shouldShowEmailError ? 1 : 0)
        )
    }
    
    private var verificationButton: some View {
        Button {
            store.send(.verificationButtonTapped(type))
        } label: {
            Text(store.verificationButtonState.buttonText)
                .foregroundStyle(store.verificationButtonState.textColor)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 114, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(store.verificationButtonState.backgroundColor)
                        .stroke(store.verificationButtonState.borderColor, lineWidth: 1)
                )
        }
        .disabled(!store.verificationButtonState.isEnabled)
    }
    
    private var verificationTextField: some View {
        HStack {
            TextField(
                "",
                text: $store.verificationCode,
                prompt: Text("인증번호 입력").foregroundStyle(Color.Kuring.caption1)
            )
            .keyboardType(.numbersAndPunctuation)
            .submitLabel(.done)
            
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
                    verificationFieldBorderColor,
                    lineWidth: store.verificationCode.isEmpty ? 0 : 1
                )
        )
    }
}

// MARK: - Helper properties & function
extension EmailVerification {
    private var shouldShowEmailError: Bool {
        return store.emailState == .invalid
    }
    
    private var emailBorderColor: Color {
        if case .invalid = store.emailState {
            return Color.Kuring.warning
        }
        return Color.clear
    }
    
    private var verificationFieldBorderColor: Color {
        switch store.verificationState {
        case .invalid:
            return Color.Kuring.warning
        case .active:
            return Color.Kuring.primary
        case .hidden:
            return Color.clear
        }
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
