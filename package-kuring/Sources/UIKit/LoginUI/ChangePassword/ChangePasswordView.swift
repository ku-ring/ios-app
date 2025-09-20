//
//  ChangePassword.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/8/25.
//

import SwiftUI
import ColorSet
import LoginFeatures
import ComposableArchitecture

public struct ChangePasswordView: View {
    @Bindable var store: StoreOf<SetPasswordFeature>
    
    public var body: some View {
        VStack(spacing: 8) {
            HeaderView(
                title: "비밀번호 재설정하기",
                subtitle: "6~20자 영문 소문자, 숫자를 조합하여 비밀번호를 생성해주세요 :)"
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            
            SetUpPassword(store: store)
            
            Spacer()
            
            ActionButton(
                title: "확인",
                isActive: .init(get: { store.isValidReEnterPassword }, set: {_ in })
            ) {
                store.send(.actionButtonTapped(.changePassword))
            }
            .padding(.top, 16)
        }
        .padding(20)
        .background(Color.Kuring.bg)
    }
    
    public init(store: StoreOf<SetPasswordFeature>) {
        self.store = store
    }
}
