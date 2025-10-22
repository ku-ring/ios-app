//
//  AcademicCalendar.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/20/25.
//

import SwiftUI
import ColorSet
import Combine
import CommonUI

struct AcademicCalendar: View {
    @State private var currentDate = Date()
    @State private var selectedDate: Date?
    @State private var months: [Date] = []
    @State private var currentMonthIndex = 1
    
    @State private var dateDots: [String: [Color]] = [
        "2025-8-7": [.yellow, .green, .gray],
        "2025-8-13": [.yellow],
        "2025-8-18": [.green],
        "2025-8-20": [.green]
    ]
    
    let calendar = Calendar.current
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    
    @State private var pageIdx = 1
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Text(monthYearString)
                        .font(.system(size: 18, weight: .semibold))
                    
                    Spacer()
                    
                    HStack(spacing: 26) {
                        Button {
                            currentMonthIndex -= 1
                            handleInfiniteScroll(for: currentMonthIndex)
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.green)
                                .font(.system(size: 20))
                        }
                        
                        Button {
                            currentMonthIndex += 1
                            handleInfiniteScroll(for: currentMonthIndex)
                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.green)
                                .font(.system(size: 20))
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                HStack(spacing: 18) {
                    ForEach(weekdays, id: \.self) { day in
                        Text(day)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color.Kuring.gray300)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 19.5)
                .padding(.top, 16)
            }
            
            ScrollViewReader { proxy in
                TabView(selection: $currentMonthIndex) {
                    ForEach(Array(months.enumerated()), id: \.offset) { index, month in
                        CalendarMonthView(
                            month: month,
                            selectedDate: $selectedDate,
                            dateDots: dateDots
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never)) // Snap-style scroll
                .frame(height: 380)
                .onChangeDebounced(of: currentMonthIndex, delay: 0.3) { newIndex in
                    handleInfiniteScroll(for: newIndex)
                }
                .onAppear {
                    initializeMonths()
                }
            }
        }
    }
    
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

    func handleInfiniteScroll(for index: Int) {
        guard !months.isEmpty else { return }

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
