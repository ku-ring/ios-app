//
//  NextButton.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/8/25.
//

import SwiftUI
import ColorSet

struct ActionButton: View {
    let title: String
    var isActive: Bool
    let activeColor: Color = .Kuring.primary
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
