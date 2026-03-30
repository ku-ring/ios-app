//
//  ClubsTypeColumn.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/8/26.
//

import Models
import SwiftUI
import ColorSet

public struct ClubsTypeColumn: View {
    public let original: ClubsType
    public let selection: ClubsType
    
    private var isSelected: Bool {
        original == selection
    }
    
    public var body: some View {
        Text(original.title)
            .frame(maxWidth: .infinity)
            .font(.system(size: 16, weight: isSelected ? .semibold : .medium))
            .padding(.vertical, 8)
            .frame(height: 48)
            .overlay {
                VStack {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 3)
                        .opacity(isSelected ? 1 : 0)
                }
            }
            .foregroundStyle(
                isSelected
                ? Color.Kuring.primary
                : Color.Kuring.caption1
            )
    }

    public init(original: ClubsType, selection: ClubsType) {
        self.original = original
        self.selection = selection
    }
}
