//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import ColorSet

// TODO: 디자인 시스템으로 이동
struct KuringButtonStyle: ButtonStyle {
    fileprivate let onEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()
            
            configuration.label
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(
                    onEnabled
                    ? .white
                    : ColorSet.primary.opacity(0.4)
                )

            Spacer()
        }
        .padding(.horizontal, 50)
        .padding(.vertical, 16)
        .frame(height: 50, alignment: .center)
        .background(
            onEnabled
            ? ColorSet.primary
            : ColorSet.primary.opacity(0.15)
        )
        .cornerRadius(100)
    }
}

extension ButtonStyle where Self == KuringButtonStyle {
    static func kuringStyle(enabled: Bool = true) -> Self {
        Self(onEnabled: enabled)
    }
}
