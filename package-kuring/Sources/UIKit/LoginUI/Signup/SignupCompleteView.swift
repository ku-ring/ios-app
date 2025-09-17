//
//  SignupCompleteView.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/17/25.
//

import Lottie
import SwiftUI
import ColorSet

struct SignupCompleteView: View {
    var body: some View {
        VStack(spacing: 8) {
            HeaderView(
                title: "회원가입이 완료되었어요!",
                subtitle: "이어서 쿠링을 더 다채롭게 이용해보세요!"
            )
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 89)
            
            Spacer()
            
            LottieView(animation: .named("signup_complete.json", bundle: Bundle.bots))
                .looping()
                .resizable()
            
            Spacer()
            
            ActionButton(
                title: "로그인 후 쿠링 계속하기",
                isActive: .constant(true)
            ) {
                
            }
        }
        .padding(20)
        .background(Color.Kuring.bg)
    }
}

#Preview {
    SignupCompleteView()
}
