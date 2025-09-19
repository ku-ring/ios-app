//
//  FindPassword.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/7/25.
//

import SwiftUI
import ColorSet
import LoginFeatures
import ComposableArchitecture

public struct FindPasswordView: View {
    @Bindable var store: StoreOf<EmailVerificationFeature>
    
    public var body: some View {
        VStack(spacing: 8) {
            HeaderView(
                title: "비밀번호 찾기",
                subtitle: "학교 이메일 주소를 입력하여 본인인증 해주세요."
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            
            EmailVerification(store: store)
            .padding(.top, 45)
            
            Spacer()
            
            goToEmail
            ActionButton(
                title: "본인인증 완료",
                isActive: $store.canVerifyCode,
                action: {
                    store.send(.actionButtonPressed(.findPassword))
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
