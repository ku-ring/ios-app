//
//  SetUpPassword.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/9/25.
//

import SwiftUI
import ColorSet

struct PasswordValidator {
    static let passwordRegex = #"^(?=.*[a-z])(?=.*\d)[a-z\d]{6,20}$"#
    
    static func isValidPassword(_ password: String) -> Bool {
        return password.range(of: passwordRegex, options: .regularExpression) != nil
    }
}

/// 비밀번호 입력/재입력을 통해 비밀번호를 설정하거나 재설정할때 사용되는 뷰
/// ```swift
///     SetUpPassword(canProceed: $canProceed)
/// ```
///  - Parameters:
///    - canProceed: 다음 단계로 넘어갈수 있을지 나타내는 부울값
struct SetUpPassword: View {
    enum FocusedField: Hashable {
        case password, reEnterPassword
    }
    
    @FocusState private var focusedField: FocusedField?
    @Binding var canProceed: Bool
    @State private var password: String = ""
    @State private var reEnterPassword: String = ""
    @State private var showPassword = false
    @State private var showReEnterPassword = false
    
    private var isValidPassword: Bool {
        PasswordValidator.isValidPassword(password)
    }
    
    private var isValidReEnterPassword: Bool {
        isValidPassword && !reEnterPassword.isEmpty && password == reEnterPassword
    }
    
    var body: some View {
        VStack(spacing: 8) {
            enterPasswordTextField
            reEnterPasswordTextField
        }
        .onChange(of: password) { _ in
            canProceed = isValidReEnterPassword
        }
        .onChange(of: reEnterPassword) { _ in
            canProceed = isValidReEnterPassword
        }
    }
    
    private var enterPasswordTextField: some View {
        VStack {
            PasswordTextField(
                showInput: $showPassword,
                input: $password,
                placeholder: "비밀번호"
            )
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.Kuring.gray100)
                    .stroke(
                        isValidPassword ? Color.Kuring.primary : Color.Kuring.warning,
                        lineWidth: password.isEmpty ? 0 : 1
                    )
            )
            .focused($focusedField, equals: .password)
            .submitLabel(.next)
            .onSubmit {
                focusedField = .reEnterPassword
            }
            
            if !password.isEmpty && !isValidPassword {
                LoginErrorMessage(message: "6~20자 영문 소문자, 숫자를 조합하여 입력해주세요.")
            }
        }
        .padding(.top, 45)
    }
    
    private var reEnterPasswordTextField: some View {
        VStack {
            PasswordTextField(
                showInput: $showReEnterPassword,
                input: $reEnterPassword,
                placeholder: "비밀번호 재확인"
            )
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.Kuring.gray100)
                    .stroke(
                        isValidReEnterPassword ? Color.Kuring.primary : Color.Kuring.warning,
                        lineWidth: reEnterPassword.isEmpty ? 0 : 1
                    )
            )
            .focused($focusedField, equals: .reEnterPassword)
            .submitLabel(.done)
            .onSubmit {
                focusedField = nil
            }
            
            if !reEnterPassword.isEmpty && !isValidReEnterPassword {
                LoginErrorMessage(message: "비밀번호가 일치하지 않아요.")
            }
        }
    }
}

#Preview {
    @Previewable @State var canProceed: Bool = false
    SetUpPassword(canProceed: $canProceed)
}
