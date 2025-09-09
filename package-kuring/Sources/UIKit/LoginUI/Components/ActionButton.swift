//
//  NextButton.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/8/25.
//

import SwiftUI
import ColorSet

/// 상태에 따라 활성화 또는 비활성화가 될수 있는  "확인", "완료", "다음"과 같은 버튼.
/// ```swift
///  ActionButton(title: "확인", isActive: $isActive, activeColor: Color.kuring.warning, action: { doSomething() })
/// ```
///  - Parameters:
///    - title: 버튼 제목
///    - isActive: 활성화 상태를 나타내는 부울값. 만약 활성화 상태가 바뀌지 않는 버튼이라면 .constant(true)
///    - activeColor: 활성화 상태의 색깔. 기본은 Kuring.primary
///    - action: 주입받을 액션
struct ActionButton: View {
    let title: String
    @Binding var isActive: Bool
    var activeColor: Color = .Kuring.primary
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(isActive ? Color.Kuring.bg : Color.Kuring.caption1)
                .frame(height: 56)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    Capsule()
                        .fill(isActive ? activeColor : Color.Kuring.gray200)
                )
        }
        .disabled(!isActive)
    }
}
