//
//  UnivNoticeTypeSelector.swift
//
//
//  Created by Jaesung Lee on 2023/09/15.
//

import SwiftUI

struct UnivNoticeTypeSelector: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(["학사", "취창업", "국제", "장학", "입학", "학생", "산학", "일반"], id: \.self) { noticeType in
                ZStack {
                    Color(.systemGroupedBackground)
                        .cornerRadius(15)
                    
                    VStack {
                        Image(noticeType, bundle: Bundle.module)
                        
                        Text(noticeType)
                    }
                    .padding()
                }
                .padding(.horizontal, 10)
            }
        }
    }
}

struct UnivNoticeTypeSelector_Previews: PreviewProvider {
    static var previews: some View {
        UnivNoticeTypeSelector()
    }
}
