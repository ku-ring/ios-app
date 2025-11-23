//
//  EmailTextField.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/8/25.
//

import SwiftUI
import ColorSet

/// 로그인에 사용되는 이메일 텍스트 필드 UI
/// ```swift
///   EmailTextField(email: $email, placeholder: "학교 이메일 주소")
/// ```
///  - Parameters:
///    - email: 바인딩할 이메일 입력값
///    - placeholder: 아무것도 입력하지 않았을때 보여질 placeholder 텍스트
struct EmailTextField: View {
    @Binding var email: String
    let placeholder: String
    
    var body: some View {
        TextField(
            "",
            text: $email,
            prompt: Text(placeholder).foregroundStyle(Color.Kuring.caption1)
        )
        .keyboardType(.emailAddress)
        .textContentType(.emailAddress)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .frame(height: 50)
        .padding(.horizontal)
    }
}
