//
//  DateCellView.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/22/25.
//

import SwiftUI

struct DateCellView: View {
    let dateInfo: DateInfo
    let isSelected: Bool
    let dots: [Color]
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(dateInfo.day)")
                    .font(.system(size: 16))
                    .foregroundColor(isSelected ? .white : (dateInfo.isCurrentMonth ? .black : .gray))
                    .background(
                        Circle()
                            .fill(isSelected ? Color.green : Color.clear)
                    )
                
                if !dots.isEmpty {
                    HStack(spacing: 0) {
                        ForEach(0..<dots.count, id: \.self) { index in
                            Rectangle()
                                .fill(dots[index])
                                .frame(width: 8, height: 4)
                        }
                    }
                    .clipShape(Capsule())
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
