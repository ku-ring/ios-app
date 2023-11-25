//
//  NoticeTypeColumn.swift
//  KuringApp
//
//  Created by 이재성 on 11/24/23.
//

import Model
import SwiftUI
import ComposableArchitecture

struct NoticeTypeColumn: View {
    let noticeType: NoticeType
    let selectedID: NoticeType.ID
    
    var body: some View {
        let itemSize: CGSize = CGSize(width: 64, height: 48)
        let lineHeight: CGFloat = 3
        
        Text(noticeType.rawValue)
            .font(.system(size: 16, weight: noticeType.id == selectedID ? .semibold : .regular))
            .padding(.vertical, 8)
            .frame(width: itemSize.width, height: itemSize.height)
            .overlay {
                VStack {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: lineHeight / 2)
                        .frame(width: itemSize.width, height: lineHeight)
                        .opacity(noticeType.id == selectedID ? 1 : 0)
                }
            }
            .foregroundStyle(
                noticeType.id == selectedID
                ? Color.accentColor
                : Color.black.opacity(0.3)
            )
            .id(noticeType.id)
    }
}
