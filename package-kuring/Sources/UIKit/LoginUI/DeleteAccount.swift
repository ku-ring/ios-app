//
//  DeleteAccount.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 8/25/25.
//

import SwiftUI
import Caches
import ColorSet

struct DeleteAccount: View {
    var body: some View {
        VStack {
            header

            disclaimer
            
            Spacer()
            
            deleteButton
        }
        .padding(20)
        .background(Color.Kuring.bg)
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("탈퇴하기")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.Kuring.title)
            
            Text("쿠링을 탈퇴하기 전에\n하단 정보를 확인해주세요.")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func disclaimerView(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.body.bold())
                .foregroundStyle(Color.Kuring.title)
            
            Text(subtitle)
                .font(.system(size: 14))
                .foregroundStyle(Color.Kuring.caption1)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(Color.Kuring.gray100, in: RoundedRectangle(cornerRadius: 8))
    }
    
    private var disclaimer: some View {
        VStack(spacing: 10) {
            disclaimerView(
                title: "처음부터 다시 가입해야해요. 🔐",
                subtitle: """
                        탈퇴 회원의 개인정보는 관련 법령에 따라 일정 기간 
                        안전하게 보관되며, 그 이후 자동 파기 되어요. 
                        다시 앱을 시작하려면 회원가입부터 다시 해야 해요.
                        """
            )
            disclaimerView(
                title: "등록된 댓글은 자동으로 삭제되지 않아요. 💬",
                subtitle: "탈퇴 전 개별적으로 삭제되었는지 확인해주세요."
            )
        }
        .padding(.top, 45)
    }
    
    private var deleteButton: some View {
        Button {
            
        } label: {
            Text("탈퇴하기")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.Kuring.bg)
                .frame(height: 56)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    Capsule()
                        .fill(Color.Kuring.warning)
                )
                .padding(.bottom, 20)
        }
    }
}
