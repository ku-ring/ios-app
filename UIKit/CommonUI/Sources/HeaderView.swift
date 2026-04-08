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
///    .frame(maxWidth: .infinity, alignment: .leading)
/// ```
///  - Parameters:
///    - title: 제목
///    - subtitle: 부제목
public struct HeaderView: View {
    let title: String
    let subtitle: String
    
    public init(
        title: String,
        subtitle: String
    ) {
        self.title = title
        self.subtitle = subtitle
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.Kuring.title)
            
            Text(subtitle)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
        }
    }
}
