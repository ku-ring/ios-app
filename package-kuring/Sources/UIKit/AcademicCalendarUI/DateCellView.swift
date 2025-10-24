//
//  DateCellView.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/22/25.
//

import Models
import SwiftUI
import ColorSet

/// 학사 일정 캘린더에 하나의 날짜를 나타내는 뷰
/// ```swift
///    DateCellView(
///        dateInfo: dateInfo,
///        isSelected: isSelected(dateInfo.date),
///        events: getEventsForDate(dateInfo.date),
///        onTap: {
///            if dateInfo.isCurrentMonth {
///                selectedDate = dateInfo.date
///            }
///        }
///    )
/// ```
///  - Parameters:
///    - dateInfo: 하나의 날짜의 정보를 나타내는 DateInfo 객체. 해당 날짜, day(월~일), 그리고 currentMonth 정보를 담고있음.
///    - isSelected: 사용자가 탭하여 선택한 날짜인지 나타내는 값
///    - dots: 해당 날짜의 학사일정들, 있다면
///    - onTap: 날짜를 탭했을때 액션을 수행함
struct DateCellView: View {
    let dateInfo: DateInfo
    let isSelected: Bool
    let events: [AcademicEvent]
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
                
                if !events.isEmpty {
                    HStack(spacing: 0) {
                        ForEach(0..<events.count, id: \.self) { index in
                            Rectangle()
                                .fill(.green)
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
        events: []
    ) {
        print("Tapped")
    }
}
