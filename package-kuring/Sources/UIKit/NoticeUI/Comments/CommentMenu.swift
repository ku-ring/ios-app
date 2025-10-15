//
//  CommentMenu.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/2/25.
//

import SwiftUI
import ColorSet

/// 하나의 댓글의 우측 상단에 위치한 메뉴 버튼
/// ```swift
/// CommentMenu(
///    isOwner: comment.isMine,
///    onDelete: { onDelete(comment) },
///    onReport: { onReport(comment) }
/// )
/// ```
///  - Parameters:
///    - isOwner: 댓글이 내꺼라면 삭제 가능. 내꺼인지는 Comment 객체의 isMine 프로퍼티로 판별
///    - onDelete: 삭제시 이뤄질 액션(API)
///    - onReport: 신고시 이뤄질 액션(API)
struct CommentMenu: View {
    let isOwner: Bool
    let onDelete: () -> Void
    let onReport: () -> Void
    
    var body: some View {
        Menu {
            Button {
                onReport()
            } label: {
                Label {
                    Text("신고하기")
                } icon: {
                    Image("siren", bundle: .module)
                        .renderingMode(.template)
                        .foregroundStyle(Color.Kuring.body)
                }
            }
            
            if isOwner {
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("삭제하기", systemImage: "trash")
                }
            }
        } label: {
            Image("more_vertical", bundle: .module)
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.Kuring.gray400)
        }
        .menuStyle(.borderlessButton)
    }
}

#Preview {
    CommentMenu(
        isOwner: false,
        onDelete: { },
        onReport: { }
    )
}
