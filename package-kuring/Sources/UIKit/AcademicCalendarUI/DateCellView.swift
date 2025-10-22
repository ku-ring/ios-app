//
//  DateCellView.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/22/25.
//

import SwiftUI
import ColorSet

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
                    .foregroundColor(isSelected ? Color.Kuring.primary : (dateInfo.isCurrentMonth ? Color.Kuring.title : Color.Kuring.gray300))
                    .background(
                        Circle()
                            .fill(isSelected ? Color.Kuring.primarySelected : Color.clear)
                            .frame(width: 26, height: 26)
                    )
                
                if !dots.isEmpty {
                    HStack(spacing: 0) {
                        ForEach(0..<dots.count, id: \.self) { index in
                            Rectangle()
                                .fill(dots[index])
                                .frame(width: 5, height: 5)
                        }
                    }
                    .clipShape(Capsule())
                    .padding(.top, 4)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DateCellView(
        dateInfo: .init(
            date: Date(),
            day: 3,
            isCurrentMonth: true
        ),
        isSelected: true,
        dots: [
            .red, .green, .yellow
        ]
    ) {
        print("Tapped")
    }
}
