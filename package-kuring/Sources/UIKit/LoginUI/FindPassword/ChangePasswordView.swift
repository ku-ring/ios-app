//
//  ChangePassword.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/8/25.
//

import SwiftUI
import ColorSet

struct ChangePasswordView: View {
    @State private var canProceed: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            HeaderView(
                title: "비밀번호 재설정하기",
                subtitle: "6~20자 영문 소문자, 숫자를 조합하여 비밀번호를 생성해주세요 :)"
            )
            
            SetUpPassword(canProceed: $canProceed)
            
            Spacer()
            
            ActionButton(
                title: "확인",
                isActive: $canProceed
            ) {
                
            }
            .padding(.top, 16)
        }
        .padding(20)
        .background(Color.Kuring.bg)
    }
}

#Preview {
    ChangePasswordView()
}
