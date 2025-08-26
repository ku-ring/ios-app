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
            VStack(alignment: .leading, spacing: 8) {
                Text("탈퇴가 완료되었어요.")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.Kuring.title)
                
                Text("쿠링이 필요할 때 또 만나요!")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.Kuring.caption1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
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
