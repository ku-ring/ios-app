//
//  FindPassword.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/7/25.
//

import SwiftUI
import ColorSet

struct FindPassword: View {
    @State private var canProceed: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            HeaderView(
                title: "비밀번호 찾기",
                subtitle: "학교 이메일 주소를 입력하여 본인인증 해주세요."
            )
            EmailVerification(canProceed: $canProceed)
                .padding(.top, 45)
            
            Spacer()
            
            goToEmail
            ActionButton(title: "다음", isActive: $canProceed) {
                
            }
            .padding(.top, 16)
        }
        .padding(20)
        .background(Color.Kuring.bg)
    }
    
    /// 학교 이메일 바로가기
    private var goToEmail: some View {
        Text("학교 메일 바로가기 >")
            .font(.subheadline.weight(.medium))
            .foregroundStyle(Color.Kuring.caption1)
            .frame(maxWidth: .infinity, alignment: .center)
            .onTapGesture {
                // do something
            }
    }
}

#Preview {
    FindPassword()
}
