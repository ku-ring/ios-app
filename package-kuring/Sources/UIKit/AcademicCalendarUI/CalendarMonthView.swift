//
//  CalendarMonthView.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/22/25.
//

import SwiftUI

struct DateInfo {
    let date: Date
    let day: Int
    let isCurrentMonth: Bool
}

struct CalendarMonthView: View {
    let month: Date
    @Binding var selectedDate: Date?
    let dateDots: [String: [Color]]
    
    let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<numberOfWeeks, id: \.self) { weekIndex in
                HStack {
                    ForEach(0..<7) { dayIndex in
                        if let dateInfo = getDateInfo(for: weekIndex, dayIndex: dayIndex) {
                            DateCellView(
                                dateInfo: dateInfo,
                                isSelected: isSelected(dateInfo.date),
                                dots: getDotsForDate(dateInfo.date),
                                onTap: {
                                    if dateInfo.isCurrentMonth {
                                        selectedDate = dateInfo.date
                                    }
                                }
                            )
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: rowHeight)
                        } else {
                            Color.clear
                                .frame(maxWidth: .infinity)
                                .frame(height: rowHeight)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 19.5)
        .frame(width: UIScreen.main.bounds.width)
    }
}

extension CalendarMonthView {
    var numberOfWeeks: Int {
        let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let daysInMonth = calendar.range(of: .day, in: .month, for: month)!.count
        
        let totalDays = firstWeekday + daysInMonth - 1
        return Int(ceil(Double(totalDays) / 7.0))
    }
    
    var rowHeight: CGFloat {
        return 306.0 / CGFloat(numberOfWeeks)
    }
    
    func getDateInfo(for weekIndex: Int, dayIndex: Int) -> DateInfo? {
        let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        
        let dayOffset = weekIndex * 7 + dayIndex - firstWeekday + 1
        
        guard let date = calendar.date(byAdding: .day, value: dayOffset, to: firstDay) else {
            return nil
        }
        
        let isCurrentMonth = calendar.isDate(date, equalTo: month, toGranularity: .month)
        let day = calendar.component(.day, from: date)
        
        return DateInfo(date: date, day: day, isCurrentMonth: isCurrentMonth)
    }
    
    func isSelected(_ date: Date) -> Bool {
        guard let selectedDate = selectedDate else {
            return false
        }
        return calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    func getDotsForDate(_ date: Date) -> [Color] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-M-d"
        let dateString = formatter.string(from: date)
        return dateDots[dateString] ?? []
    }
}

#Preview {
    CalendarMonthView(
        month: Date(),
        selectedDate: .constant(Date()),
        dateDots: [
            "2025-10-22": [
                .green, .blue, .red
            ]
        ]
    )
}
