//
//  NoticeList.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/04.
//

import SwiftUI

struct NoticeList: View {
    var body: some View {
        List {
            NoticeRow(
                notice: Notice(
                    articleId: "123",
                    important: false,
                    subject: "코로나-19 재확산에 따른 방역 수칙 및 자발적 거리두기 중요 내용 안내",
                    url: "",
                    postedDate: "2023.01.01"
                )
            )
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("쿠링")
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "bell")
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
    }
}

struct NoticeRow: View {
    let notice: Notice
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("태그")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.background)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background {
                        Color.secondary
                            .clipShape(.capsule)
                    }
                
                Text(notice.subject)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(notice.postedDate)
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            
            Divider()
        }
        .listRowSeparator(.hidden)
    }
}

#Preview {
    NoticeList()
}
