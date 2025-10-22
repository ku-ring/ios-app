//
//  AcademicCalendar.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/20/25.
//

import SwiftUI
import ColorSet
import CommonUI

/// 학사 일정 캘린더 뷰
/// ```swift
///   AcademicCalendar()
/// ```
///  - Parameters: none
struct AcademicCalendar: View {
    @State private var currentDate = Date()
    @State private var selectedDate: Date?
    @State private var months: [Date] = []
    @State private var currentMonthIndex = 1
    
    @State private var eventDots: [String: [Color]] = [
        "2025-10-7": [.yellow, .green, .gray],
        "2025-10-13": [.yellow],
        "2025-10-18": [.green],
        "2025-10-20": [.green]
    ]
    
    let calendar = Calendar.current
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                headerView
                weekdaysView
            }
            calendarContent
        }
    }
    
    private var headerView: some View {
        HStack {
            Text(monthYearString)
                .font(.system(size: 18, weight: .semibold))
            
            Spacer()
            
            HStack(spacing: 26) {
                Button {
                    currentMonthIndex -= 1
                    handleMonthChange(for: currentMonthIndex)
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.Kuring.primary)
                        .font(.system(size: 20, weight: .medium))
                }
                
                Button {
                    currentMonthIndex += 1
                    handleMonthChange(for: currentMonthIndex)
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.Kuring.primary)
                        .font(.system(size: 20, weight: .medium))
                }
            }
        }
        .padding(.horizontal, 30)
    }
    
    private var weekdaysView: some View {
        HStack {
            ForEach(weekdays, id: \.self) { day in
                Text(day)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color.Kuring.gray300)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 19.5)
        .padding(.top, 24)
    }
    
    private var calendarContent: some View {
        ScrollViewReader { proxy in
            TabView(selection: $currentMonthIndex) {
                ForEach(Array(months.enumerated()), id: \.offset) { index, month in
                    CalendarMonthView(
                        month: month,
                        selectedDate: $selectedDate,
                        eventDots: eventDots
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 306)
            .onChangeDebounced(of: currentMonthIndex, delay: 0.3) { newIndex in
                handleMonthChange(for: newIndex)
            }
            .onAppear {
                initializeMonths()
            }
        }
    }
}

extension AcademicCalendar {
    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 yyyy"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: currentDate)
    }
    
    func initializeMonths() {
        let prevMonth = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
        months = [prevMonth, currentDate, nextMonth]
    }

    func handleMonthChange(for index: Int) {
        guard !months.isEmpty else {
            return
        }

        if index == 0 {
            let newPrev = calendar.date(byAdding: .month, value: -1, to: months.first!)!
            months.insert(newPrev, at: 0)
            currentMonthIndex = 1
        } else if index == months.count - 1 {
            let newNext = calendar.date(byAdding: .month, value: 1, to: months.last!)!
            months.append(newNext)
        }
        currentDate = months[currentMonthIndex]
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        AcademicCalendar()
    }
}
