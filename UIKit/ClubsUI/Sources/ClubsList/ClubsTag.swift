//
//  ClubsTag.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/8/26.
//

import SwiftUI
import ColorSet

struct ClubsTag: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? Color.Kuring.primary : Color.Kuring.caption1)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                          .fill(isSelected ? Color.Kuring.primarySelected : Color.Kuring.bg)
                          .overlay(
                              Capsule()
                                  .strokeBorder(
                                      isSelected ? Color.Kuring.primary : Color.Kuring.gray200,
                                      lineWidth: 1
                                  )
                          )
                )
        }
    }
}
