//
//  CommentMenu.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/2/25.
//

import SwiftUI

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
                .resizable()
                .frame(width: 24, height: 24)
        }
        .menuStyle(.borderlessButton)
    }
}
