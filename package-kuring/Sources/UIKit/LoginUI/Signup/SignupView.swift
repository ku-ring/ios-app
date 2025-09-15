//
//  SignupView.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/9/25.
//

import SwiftUI
import ColorSet
import LoginFeatures
import ComposableArchitecture

public struct SignupView: View {
    @State private var store: StoreOf<EmailVerificationFeature> = .init(initialState: EmailVerificationFeature.State(verificationType: .signup), reducer: {
        EmailVerificationFeature()
    })
    
    public var body: some View {
        VStack(spacing: 8) {
            HeaderView(
                title: "재학생 인증 및 아이디 생성",
                subtitle: "학교 이메일 계정으로 본교 학생임을 인증해주세요.\n이메일 주소는 아이디로 사용될 예정이에요."
            )
            EmailVerification(store: store)
                .padding(.top, 45)
            
            Spacer()
            
            goToEmail
            ActionButton(title: "확인", isActive: $store.canProceed) {
                
            }
            .padding(.top, 16)
        }
        .padding(20)
        .background(Color.Kuring.bg)
    }
    
    /// 학교 이메일 바로가기
    private var goToEmail: some View {
        Button {
            // do something
        } label: {
            Text("학교 메일 바로가기 >")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color.Kuring.caption1)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    public init() {}
}

