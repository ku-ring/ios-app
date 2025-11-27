//
//  LoginErrorMessage.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/8/25.
//

import SwiftUI
import ColorSet

/// 텍스트 필드 입력값이 잘못됐을때 텍스트필드 아래 나타나게 되는 빨간색 에러 메세지
/// ```swift
///    LoginErrorMessage(message: "등록되지 않은 이메일이에요.")
/// ```
///  - Parameters:
///    - message: 메세지 내용
struct LoginErrorMessage: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.caption2.weight(.medium))
            .foregroundStyle(Color.Kuring.warning)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)
    }
}
