//
//  DeleteAccountConfirmation.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 8/26/25.
//

import SwiftUI
import ColorSet

struct DeleteAccountConfirmation: View {
    var body: some View {
        VStack {
            HeaderView(
                title: "탈퇴가 완료되었어요.",
                subtitle: "쿠링이 필요할 때 또 만나요!"
            )
            
            Spacer()
            
            Image("kuring.logo", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 192.59)
                .clipped()
            
            Spacer()
            
            Button {
                
            } label: {
                Text("확인")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.Kuring.bg)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(
                        Capsule()
                            .fill(Color.Kuring.primary)
                    )
                    .padding(.bottom, 20)
            }
        }
        .padding(20)
        .background(Color.Kuring.bg)
    }
}
