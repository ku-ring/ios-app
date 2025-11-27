//
//  PasswordTextField.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/8/25.
//

import SwiftUI
import ColorSet

/// 비밀번호 입력 텍스트 필드
/// ```swift
///    PasswordTextField(
///       showInput: $showPassword,
///       input: $password,
///       placeholder: "비밀번호"
///    )
/// ```
///  - Parameters:
///    - showInput: 비밀번호 숨김/노출 여부를 나타내는 부울값
///    - input: 텍스트필드 입력값
///    - placeholder: 입력값이 없을때 나타나는 placeholder 문자열
struct PasswordTextField: View {
    @Binding var showInput: Bool
    @Binding var input: String
    let placeholder: String
    
    var body: some View {
        HStack {
            Group {
                if showInput {
                    TextField(
                        "",
                        text: $input,
                        prompt: Text("\(placeholder)").foregroundStyle(Color.Kuring.caption1)
                    )
                } else {
                    SecureField(
                        "",
                        text: $input,
                        prompt: Text("\(placeholder)").foregroundStyle(Color.Kuring.caption1)
                    )
                }
            }
            .textContentType(.password)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .font(.system(size: 16, weight: .medium))
            
            Button(action: {
                showInput.toggle()
            }, label: {
                Image(
                    showInput ? "preview_open" : "preview_close",
                    bundle: .module
                )
                .renderingMode(.template)
                .foregroundStyle(Color.Kuring.body)
            })
        }
        .frame(height: 50)
        .padding(.horizontal)
    }
}
