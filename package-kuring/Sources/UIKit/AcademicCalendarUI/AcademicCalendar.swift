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
public struct AcademicCalendar: View {
    @State private var currentDate = Date()
    @State private var selectedDate: Date?
    @State private var months: [Date] = []
    @State private var currentMonthIndex = 1
    
    /// MOCK DATA
    @State private var eventDots: [String: [Color]] = [
        "2025-10-7": [.yellow, .green, .gray],
        "2025-10-13": [.yellow],
        "2025-10-18": [.green],
        "2025-10-20": [.green],
        "2025-11-3": [.green, .red, .yellow, .blue, .teal]
    ]
    
    let calendar = Calendar.current
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    
    public init() { }
    
    public var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                headerView
                weekdaysView
            }
            calendarContent
            
            Divider()
                .frame(height: 2)
                .padding(.top, 22)
            
            if let selectedDate, !getDotsForDate(selectedDate).isEmpty, isSameMonthAndYear(selectedDate, currentDate) {
                eventInfo(for: getDotsForDate(selectedDate))
            } else {
                Spacer()
            }
        }
        .background(Color.Kuring.bg)
        .navigationTitle("더보기")
        .navigationBarTitleDisplayMode(.inline)
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
    
    @ViewBuilder
    private func eventInfo(for events: [Color]) -> some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                ForEach(events, id: \.self) { color in
                    VStack(alignment: .leading) {
                        HStack(spacing: 8) {
                            Capsule()
                                .fill(color)
                                .frame(width: 4)
                                .frame(maxHeight: .infinity)
                            
                            VStack(spacing: 8) {
                                Text("수강 바구니 1차")
                                    .foregroundStyle(Color.Kuring.title)
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("8. 04 (월) 오전 9:30 - 8. 05 (화) 오전 9:30 ")
                                    .foregroundStyle(Color.Kuring.caption1)
                                    .font(.system(size: 12, weight: .medium))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        Divider()
                            .padding(.top, 16)
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 20)
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.never)
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
    
    func getDotsForDate(_ date: Date) -> [Color] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-M-d"
        let dateString = formatter.string(from: date)
        return eventDots[dateString] ?? []
    }
    
    func isSameMonthAndYear(_ d1: Date, _ d2: Date) -> Bool {
        calendar.isDate(d1, equalTo: d2, toGranularity: .month)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        AcademicCalendar()
    }
}
