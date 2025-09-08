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
    
    private var isValidPassword: Bool {
        PasswordValidator.isValidPassword(password)
    }
    
    private var isValidReEnterPassword: Bool {
        password == reEnterPassword
    }
    
    @State private var showPassword = false
    @State private var showReEnterPassword = false
    
    var body: some View {
        VStack {
            HeaderView(
                title: "비밀번호 재설정하기",
                subtitle: "6~20자 영문 소문자, 숫자를 조합하여 비밀번호를 생성해주세요 :)"
            )
            
            enterPasswordTextField
            reEnterPasswordTextField
            
            Spacer()
            
            confirmButton
        }
        .padding(20)
        .background(Color.Kuring.bg)
    }
    
    private var enterPasswordTextField: some View {
        VStack {
            HStack {
                Group {
                    if showPassword {
                        TextField(
                            "",
                            text: $password,
                            prompt: Text("비밀번호").foregroundStyle(Color.Kuring.caption1)
                        )
                    } else {
                        SecureField(
                            "",
                            text: $password,
                            prompt: Text("비밀번호").foregroundStyle(Color.Kuring.caption1)
                        )
                    }
                }
                .focused($focusedField, equals: .password)
                .textContentType(.password)
                .autocorrectionDisabled()
                .textCase(.lowercase)
                .font(.system(size: 16, weight: .medium))
                .onSubmit {
                    focusedField = .reEnterPassword
                }
                
                Button(action: {
                    self.showPassword.toggle()
                }, label: {
                    Image(
                        self.showPassword ? "preview_open" : "preview_close",
                        bundle: .module
                    )
                    .foregroundColor(.secondary)
                })
            }
            .frame(height: 50)
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.Kuring.gray100)
                    .stroke(
                        isValidPassword ? Color.Kuring.primary : Color.Kuring.warning,
                        lineWidth: password.isEmpty ? 0 : 1
                    )
            )
            
            if !password.isEmpty && !isValidPassword {
                errorMessage("6~20자 영문 소문자, 숫자를 조합하여 입력해주세요.")
            }
        }
        .padding(.top, 45)
    }
    
    private var reEnterPasswordTextField: some View {
        VStack {
            HStack {
                Group {
                    if showReEnterPassword {
                        TextField(
                            "",
                            text: $reEnterPassword,
                            prompt: Text("비밀번호 재확인").foregroundStyle(Color.Kuring.caption1)
                        )
                    } else {
                        SecureField(
                            "",
                            text: $reEnterPassword,
                            prompt: Text("비밀번호 재확인").foregroundStyle(Color.Kuring.caption1)
                        )
                    }
                }
                .focused($focusedField, equals: .password)
                .textContentType(.password)
                .autocorrectionDisabled()
                .textCase(.lowercase)
                .font(.system(size: 16, weight: .medium))
                .onSubmit {
                    focusedField = nil
                }
                
                Button(action: {
                    self.showReEnterPassword.toggle()
                }, label: {
                    Image(
                        self.showReEnterPassword ? "preview_open" : "preview_close",
                        bundle: .module
                    )
                    .foregroundColor(.secondary)
                })
            }
            .frame(height: 50)
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.Kuring.gray100)
                    .stroke(
                        isValidReEnterPassword ? Color.Kuring.primary : Color.Kuring.warning,
                        lineWidth: reEnterPassword.isEmpty ? 0 : 1
                    )
            )
            
            if !reEnterPassword.isEmpty && !isValidReEnterPassword {
                errorMessage("비밀번호가 일치하지 않아요.")
            }
        }
    }
    
    /// 확인 버튼
    private var confirmButton: some View {
        Button {
            
        } label: {
            Text("확인")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(!reEnterPassword.isEmpty && isValidReEnterPassword ? Color.Kuring.bg : Color.Kuring.caption1)
                .frame(height: 56)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    Capsule()
                        .fill(!reEnterPassword.isEmpty && isValidReEnterPassword ? Color.Kuring.primary : Color.Kuring.gray200)
                )
        }
        .padding(.top, 16)
    }
    
    private func errorMessage(_ text: String) -> some View {
        Text(text)
            .font(.caption2.weight(.medium))
            .foregroundStyle(Color.Kuring.warning)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)
    }
}

#Preview {
    ChangePassword()
}
