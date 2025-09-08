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
            HeaderView(
                title: "로그인",
                subtitle: "로그인 후 쿠링과 함께\n다채로운 캠퍼스 생활을 즐겨보세요 :)"
            )
            
            loginForm
            ActionButton(title: "로그인", isActive: true) {
                
            }
            .padding(.top, 33)
            footer
            
            Spacer()
        }
        .padding(20)
        .background(Color.Kuring.bg)
    }
}

// MARK: - View Components
extension LoginView {
    /// 로그인 텍스트필드 영역 (이메일, 비밀번호 입력)
    private var loginForm: some View {
        VStack(spacing: 8) {
            EmailTextField(email: $email, placeholder: "학교 이메일 주소")
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.Kuring.gray100)
                )
                .focused($focusedField, equals: .username)
                .onSubmit {
                    focusedField = .password
                }
            
            PasswordTextField(
                showInput: $showPassword,
                input: $password,
                placeholder: "6~20자 영문 소문자+숫자"
            )
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.Kuring.gray100)
            )
            .focused($focusedField, equals: .password)
            .onSubmit {
                focusedField = nil
            }
        }
        .padding(.top, 45)
    }
    
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
