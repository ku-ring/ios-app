//
//  SignupView.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/9/25.
//

import SwiftUI
import CommonUI
import ColorSet
import LoginFeatures
import SettingsFeatures
import ComposableArchitecture

public struct SignupView: View {
    @Bindable var store: StoreOf<EmailVerificationFeature>
    
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
            
            ActionButton(
                title: "다음",
                isActive: $store.canVerifyCode,
                action: {
                    store.send(.actionButtonPressed)
                }
            )
            .padding(.top, 16)
        }
        .padding(20)
        .background(Color.Kuring.bg)
        .sheet(
            item: $store.scope(
                state: \.destination?.schoolEmail,
                action: \.destination.schoolEmail
            )
        ) { store in
            LoginWebView(store: store)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
    
    /// 학교 이메일 바로가기
    private var goToEmail: some View {
        Button {
            store.send(.showSchoolEmailButtonTapped)
        } label: {
            Text("학교 메일 바로가기 >")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color.Kuring.caption1)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    public init(store: StoreOf<EmailVerificationFeature>) {
        self.store = store
    }
}

