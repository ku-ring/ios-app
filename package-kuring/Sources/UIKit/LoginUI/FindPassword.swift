//
//  FindPassword.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/7/25.
//

import SwiftUI
import ColorSet

private enum VerificationButtonState {
    case disabled
    case send
    case resend
    
    var buttonText: String {
        switch self {
        case .disabled, .send:
            return "인증번호"
        case .resend:
            return "재전송"
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .disabled:
            return false
        case .send, .resend:
            return true
        }
    }
    
    var textColor: Color {
        switch self {
        case .disabled:
            return Color.Kuring.caption1
        case .send, .resend:
            return Color.Kuring.primary
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .disabled:
            return Color.Kuring.gray100
        case .send, .resend:
            return Color.Kuring.primarySelected
        }
    }
    
    var borderColor: Color {
        switch self {
        case .disabled:
            return Color.Kuring.caption2
        case .send, .resend:
            return Color.Kuring.primary
        }
    }
}

struct FindPassword: View {
    @State private var email: String = ""
    @State private var verificationCode: String = ""
    @State private var verificationState: VerificationButtonState = .disabled
    @State private var timer: Timer?
    @State private var timeRemaining = 180
    
    private var isValidEmail: Bool {
        email.isEmpty || email.hasSuffix("@konkuk.ac.kr")
    }
    
    private var isValidVerificationCode: Bool {
        verificationCode == "1234" // 임시
    }
    
    private var verificationCodeBorderColor: Color {
        verificationCode.isEmpty ? .clear : (isValidVerificationCode ? Color.Kuring.primary : Color.Kuring.warning)
    }
    
    private var canProceed: Bool {
        isValidVerificationCode
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HeaderView(
                title: "비밀번호 찾기",
                subtitle: "학교 이메일 주소를 입력하여 본인인증 해주세요."
            )
            emailInputSection
            verificationInputSection
            
            Spacer()
            
            goToEmail
            ActionButton(title: "다음", isActive: canProceed) {
                
            }
            .padding(.top, 16)
        }
        .padding(20)
        .background(Color.Kuring.bg)
        .onDisappear { stopTimer() }
    }
}

//MARK: - View Components
extension FindPassword {
    
    /// 이메일 입력 영역
    private var emailInputSection: some View {
        VStack(spacing: 4) {
            HStack {
                emailTextField
                verificationButton
            }
            
            if !isValidEmail {
                LoginErrorMessage(message: "등록되지 않은 이메일이에요.")
            }
        }
        .padding(.top, 45)
    }
    
    private var emailTextField: some View {
        EmailTextField(
            email: $email,
            placeholder: "학교 이메일 주소"
        )
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.Kuring.gray100)
                .stroke(Color.Kuring.warning, lineWidth: isValidEmail ? 0 : 1)
        )
        .onChange(of: email) { _, newValue in
            updateButtonState()
        }
    }
    
    private var verificationButton: some View {
        Button {
            handleVerificationAction()
        } label: {
            Text(verificationState.buttonText)
                .foregroundStyle(verificationState.textColor)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 114, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(verificationState.backgroundColor)
                        .stroke(verificationState.borderColor, lineWidth: 1)
                )
        }
    }
    
    /// 인증번호
    private var verificationInputSection: some View {
        VStack(spacing: 4) {
            verificationTextField
            
            if !verificationCode.isEmpty && !isValidVerificationCode {
                LoginErrorMessage(message: "올바르지 않은 인증번호에요.")
            }
        }
    }
    
    private var verificationTextField: some View {
        HStack {
            TextField(
                "",
                text: $verificationCode,
                prompt: Text("인증번호 입력").foregroundStyle(Color.Kuring.caption1)
            )
            .keyboardType(.numberPad)
            
            Text("\(timeString(from: timeRemaining))")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.Kuring.warning)
        }
        .frame(height: 50)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.Kuring.gray100)
                .stroke(verificationCodeBorderColor, lineWidth: verificationCode.isEmpty ? 0 : 1)
        )
    }
    
    /// 학교 이메일 바로가기
    private var goToEmail: some View {
        Text("학교 메일 바로가기 >")
            .font(.subheadline.weight(.medium))
            .foregroundStyle(Color.Kuring.caption1)
            .frame(maxWidth: .infinity, alignment: .center)
            .onTapGesture {
                // do something
            }
    }
}

//MARK: - 임시 로직
extension FindPassword {
    private func updateButtonState() {
        if email.isEmpty {
            verificationState = .disabled
        } else if email == "Resend" {
            verificationState = .resend
        } else if isValidEmail {
            verificationState = .send
        }
    }
    
    private func handleVerificationAction() {
        switch verificationState {
        case .disabled:
            break
        case .send:
            startTimer()
            // send verification code
            break
        case .resend:
            // resend verification code
            break
        }
    }
    
    private func startTimer() {
        timeRemaining = 180
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
                print("Verification timer expired")
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        timeRemaining = 0
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    FindPassword()
}
