//
//  LoginView.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/6/25.
//

import SwiftUI
import ColorSet

struct LoginView: View {
    enum FocusedField: Hashable {
        case username, password
    }
    
    @FocusState private var focusedField: FocusedField?
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword = false
    
    var body: some View {
        VStack {
            header
            loginForm
            loginButton
            footer
            
            Spacer()
        }
        .padding(20)
        .background(Color.Kuring.bg)
    }
}

extension LoginView {
    /// 헤더 영역
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("로그인")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.Kuring.title)
            
            Text("로그인 후 쿠링과 함께\n다채로운 캠퍼스 생활을 즐겨보세요 :)")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension LoginView {
    /// 로그인 텍스트필드 영역 (이메일, 비밀번호 입력)
    private var loginForm: some View {
        VStack(spacing: 8) {
            emailTextField
            passwordTextField
        }
        .padding(.top, 45)
    }
    
    private var emailTextField: some View {
        TextField(
            "",
            text: $email,
            prompt: Text("학교 이메일 주소").foregroundStyle(Color.Kuring.caption1)
        )
        .focused($focusedField, equals: .username)
        .keyboardType(.emailAddress)
        .textContentType(.emailAddress)
        .autocorrectionDisabled()
        .textCase(.lowercase)
        .frame(height: 50)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.Kuring.gray100)
        )
        .onSubmit {
            focusedField = .password
        }
    }
    
    private var passwordTextField: some View {
        ZStack(alignment: .trailing) {
            Group {
                if showPassword {
                    TextField(
                        "",
                        text: $password,
                        prompt: Text("6~20자 영문 소문자+숫자").foregroundStyle(Color.Kuring.caption1)
                    )
                } else {
                    SecureField(
                        "",
                        text: $password,
                        prompt: Text("6~20자 영문 소문자+숫자").foregroundStyle(Color.Kuring.caption1)
                    )
                }
            }
            .focused($focusedField, equals: .password)
            .textContentType(.password)
            .autocorrectionDisabled()
            .textCase(.lowercase)
            .frame(height: 50)
            .font(.system(size: 16, weight: .medium))
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.Kuring.gray100)
            )
            .onSubmit {
                focusedField = nil
            }
            
            Button(action: {
                self.showPassword.toggle()
            }, label: {
                Image(
                    self.showPassword ? "preview_open" : "preview_close",
                    bundle: .module
                )
                .foregroundColor(.secondary)
                .padding()
            })
        }
    }
}

extension LoginView {
    /// 로그인 버튼
    private var loginButton: some View {
        Button {
            
        } label: {
            Text("로그인")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.Kuring.bg)
                .frame(height: 56)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    Capsule()
                        .fill(Color.Kuring.primary)
                )
        }
        .padding(.top, 33)
    }
}

extension LoginView {
    /// 푸터 영역 (비밀번호 찾기 / 회원가입하기)
    private var footer: some View {
        VStack(alignment: .center) {
            HStack(spacing: 50) {
                footerButton(title: "비밀번호 찾기") {
                    // action
                }
                
                Divider()
                    .frame(width: 1)
                    .frame(maxHeight: 24)
                
                footerButton(title: "회원가입하기") {
                    // action
                }
            }
            .padding(.vertical, 10)
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    private func footerButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .light))
                .foregroundStyle(Color.Kuring.caption1)
        }
    }
}

#Preview {
    LoginView()
}
