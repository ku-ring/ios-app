//
//  ChangePassword.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/8/25.
//

import SwiftUI
import ColorSet

struct PasswordValidator {
    static let passwordRegex = #"^(?=.*[a-z])(?=.*\d)[a-z\d]{6,20}$"#
    
    static func isValidPassword(_ password: String) -> Bool {
        return password.range(of: passwordRegex, options: .regularExpression) != nil
    }
}

struct ChangePassword: View {
    enum FocusedField: Hashable {
        case password, reEnterPassword
    }
    
    @FocusState private var focusedField: FocusedField?
    @State private var password: String = ""
    @State private var reEnterPassword: String = ""
    @State private var showPassword = false
    @State private var showReEnterPassword = false
    
    private var isValidPassword: Bool {
        PasswordValidator.isValidPassword(password)
    }
    
    private var isValidReEnterPassword: Bool {
        password == reEnterPassword
    }
    
    var body: some View {
        VStack {
            HeaderView(
                title: "비밀번호 재설정하기",
                subtitle: "6~20자 영문 소문자, 숫자를 조합하여 비밀번호를 생성해주세요 :)"
            )
            
            enterPasswordTextField
            reEnterPasswordTextField
            
            Spacer()
            
            ActionButton(
                title: "확인",
                isActive: !reEnterPassword.isEmpty && isValidReEnterPassword
            ) {
                
            }
            .padding(.top, 16)
        }
        .padding(20)
        .background(Color.Kuring.bg)
    }
}

//MARK: - View Components
extension ChangePassword {
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
    ChangePassword()
}
