//
//  SubscriptionSegment.swift
//  KuringApp
//
//  Created by 이재성 on 10/12/23.
//

import SwiftUI

struct SubscriptionSegment: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(
                    isSelected
                    ? Color.accentColor
                    : Color.black.opacity(0.3)
                )

            Rectangle()
                .foregroundStyle(
                    Color.accentColor
                        .opacity(isSelected ? 1 : 0)
                )
                .frame(height: 1.5)
        }
    }
}
