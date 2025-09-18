//
//  DeleteAccountConfirmation.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 8/26/25.
//

import SwiftUI
import ColorSet
import LoginFeatures
import ComposableArchitecture

public struct DeleteAccountConfirmationView: View {
    @Bindable var store: StoreOf<DeleteAccountFeature>
    
    public var body: some View {
        VStack {
            HeaderView(
                title: "탈퇴가 완료되었어요.",
                subtitle: "쿠링이 필요할 때 또 만나요!"
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Image("kuring.logo", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 192.59)
                .clipped()
            
            Spacer()
            
            ActionButton(title: "확인", isActive: .constant(true)) {
                store.send(.delegate(.popToRoot))
            }
        }
        .padding(20)
        .background(Color.Kuring.bg)
    }
    
    public init(store: StoreOf<DeleteAccountFeature>) {
        self.store = store
    }
}
