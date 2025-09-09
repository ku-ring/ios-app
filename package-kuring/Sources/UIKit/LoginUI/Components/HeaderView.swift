//
//  HeaderView.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/8/25.
//

import SwiftUI
import ColorSet

/// 헤더 뷰
/// ```swift
///    HeaderView(
///       title: "탈퇴가 완료되었어요.",
///       subtitle: "쿠링이 필요할 때 또 만나요!"
///    )
/// ```
///  - Parameters:
///    - title: 제목
///    - subtitle: 부제목
struct HeaderView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.Kuring.title)
            
            Text(subtitle)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
