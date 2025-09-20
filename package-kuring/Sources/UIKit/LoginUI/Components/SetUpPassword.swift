//
//  SetUpPassword.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/9/25.
//

import SwiftUI
import ColorSet
import LoginFeatures
import ComposableArchitecture

/// 비밀번호 입력/재입력을 통해 비밀번호를 설정하거나 재설정할때 사용되는 뷰
/// ```swift
///     SetUpPassword(password: $password, reEnterPassword: $reEnterPassword)
/// ```
///  - Parameters:
///    - password: 비밀번호
///    - reEnterPassword: 비밀번호 재입력
struct SetUpPassword: View {
    @Bindable var store: StoreOf<SetPasswordFeature>
    
    @FocusState private var focusedField: FocusedField?
    
    enum FocusedField: Hashable {
        case password, reEnterPassword
    }
    
    var body: some View {
        VStack(spacing: 8) {
            enterPasswordTextField
            reEnterPasswordTextField
        }
    }
    
    private var enterPasswordTextField: some View {
        VStack {
            PasswordTextField(
                showInput: $store.showPassword,
                input: $store.password,
                placeholder: "비밀번호"
            )
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.Kuring.gray100)
                    .stroke(
                        store.isValidPassword ? Color.Kuring.primary : Color.Kuring.warning,
                        lineWidth: store.password.isEmpty ? 0 : 1
                    )
            )
            .focused($focusedField, equals: .password)
            .submitLabel(.next)
            .onSubmit {
                focusedField = .reEnterPassword
            }
            
            if !store.password.isEmpty && !store.isValidPassword {
                LoginErrorMessage(message: "6~20자 영문 소문자, 숫자를 조합하여 입력해주세요.")
            }
        }
        .padding(.top, 45)
    }
    
    private var reEnterPasswordTextField: some View {
        VStack {
            PasswordTextField(
                showInput: $store.showReEnterPassword,
                input: $store.reEnterPassword,
                placeholder: "비밀번호 재확인"
            )
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.Kuring.gray100)
                    .stroke(
                        store.isValidReEnterPassword ? Color.Kuring.primary : Color.Kuring.warning,
                        lineWidth: store.reEnterPassword.isEmpty ? 0 : 1
                    )
            )
            .focused($focusedField, equals: .reEnterPassword)
            .submitLabel(.done)
            .onSubmit {
                focusedField = nil
            }
            
            if !store.reEnterPassword.isEmpty && !store.isValidReEnterPassword {
                LoginErrorMessage(message: "비밀번호가 일치하지 않아요.")
            }
        }
    }
}
