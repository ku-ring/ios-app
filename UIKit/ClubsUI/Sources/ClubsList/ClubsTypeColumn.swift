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
    public let title: String
    public let selection: String
    
    private var isSelceted: Bool {
        title == selection
    }
    
    public var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .font(.system(size: 16, weight: isSelceted ? .semibold : .medium))
            .padding(.vertical, 8)
            .frame(height: 48)
            .overlay {
                VStack {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 3)
                        .opacity(isSelceted ? 1 : 0)
                }
            }
            .foregroundStyle(
                isSelceted
                ? Color.Kuring.primary
                : Color.Kuring.caption1
            )
    }

    public init(key: String, selection: String) {
        self.title = key
        self.selection = selection
    }
}
