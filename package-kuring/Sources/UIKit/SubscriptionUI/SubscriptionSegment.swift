//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import ColorSet

struct SubscriptionSegment: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(
                    isSelected
                    ? ColorSet.primary
                    : ColorSet.caption1.opacity(0.3)
                )
            
            Rectangle()
                .foregroundStyle(
                    ColorSet.primary
                        .opacity(isSelected ? 1 : 0)
                )
                .frame(height: 1.5)
        }
    }
}
