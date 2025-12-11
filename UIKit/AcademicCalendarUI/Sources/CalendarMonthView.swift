//
//  CalendarMonthView.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/22/25.
//

import Models
import SwiftUI
import ComposableArchitecture
import AcademicCalendarFeatures

/// 학사 일정 캘린더에 하나의 달을 나타내는 뷰
/// 하나의 달은 "DateCellView"로 이루어져있음
/// ```swift
///   CalendarMonthView(
///       month: month,
///       selectedDate: $store.selectedDate,
///       events: store.events
///   )
/// ```
///  - Parameters:
///    - month: 해당 달의 Date 객체 (날짜 자체는 상관없음, 월만 중요함)
///    - selectedDate: 사용자가 탭하여 선택한 날짜, 바인딩이 필요하기 때문에 주입받아야함
///    - events: 해당 날짜의 학사일정들
struct CalendarMonthView: View {
    let month: Date
    @Bindable var store: StoreOf<AcademicCalendarFeature>
    let events: [AcademicEvent]
    
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
                                events: getEventsForDate(dateInfo.date),
                                onTap: {
                                    if dateInfo.isCurrentMonth {
                                        store.selectedDate = dateInfo.date
                                    } else {
                                        let comparison = calendar.compare(dateInfo.date, to: month, toGranularity: .month)
                                        store.selectedDate = dateInfo.date
                                        
                                        switch comparison {
                                        case .orderedAscending:
                                            store.send(.previousMonthTapped, animation: .snappy)
                                        case .orderedDescending:
                                            store.send(.nextMonthTapped, animation: .snappy)
                                        default:
                                            break
                                        }
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

// MARK: - Helper functions
extension CalendarMonthView {
    // 해당 월은 몇주로 이루어져있나
    private var numberOfWeeks: Int {
        let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let daysInMonth = calendar.range(of: .day, in: .month, for: month)!.count
        
        let totalDays = firstWeekday + daysInMonth - 1
        return Int(ceil(Double(totalDays) / 7.0))
    }
    
    // 캘린더 높이는 고정, 행의 높이는 동적임
    private var rowHeight: CGFloat {
        return 306.0 / CGFloat(numberOfWeeks)
    }
    
    // 몇번째 주인지, 그리고 날짜 인덱스(0~6)을 파라미터로 받고, 사용하기 쉬운 DateInfo라는 객체롴 반환.
    private func getDateInfo(for weekIndex: Int, dayIndex: Int) -> DateInfo? {
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
    
    private func isSelected(_ date: Date) -> Bool {
        guard let selectedDate = store.selectedDate else {
            return false
        }
        return calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    private func getEventsForDate(_ date: Date) -> [AcademicEvent] {
        let midnight = calendar.startOfDay(for: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateString = formatter.string(from: midnight)
        let target = dateString.prefix(10) // "2025-11-17"
        return events.filter {
            let startDay = $0.startTime.prefix(10)
            let endDay = $0.endTime.prefix(10)

            return startDay <= target && target <= endDay
        }
    }
}

/// 캘린더에 그리기 위해 필요한 정보를 담고있음.
/// - date: 날짜
/// - day: 날짜의 '일'에 해달하는 부분 (7일, 31일, 등)
/// - isCurrentMonth: 해당 월에 속하지 않은 일자인데 표시할때도 있음. 이때는 회색으로 표시해야함. 예를 들어 10월 첫째중 9월 31일이 보이는 경우, 등
struct DateInfo {
    let date: Date
    let day: Int
    let isCurrentMonth: Bool
}

#Preview {
    @Previewable @State var date: Date? = Date()
    @Previewable @State var store: StoreOf<AcademicCalendarFeature> = .init(initialState: AcademicCalendarFeature.State()) {
        AcademicCalendarFeature()
    }
    CalendarMonthView(
        month: date!,
        store: store,
        events: []
    )
}
