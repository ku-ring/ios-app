//
//  AcademicCalendar.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/20/25.
//

import Caches
import Models
import SwiftUI
import ColorSet
import CommonUI
import ComposableArchitecture
import AcademicCalendarFeatures

/// 학사 일정 캘린더 뷰
/// ```swift
///   AcademicCalendar()
/// ```
///  - Parameters: none
public struct AcademicCalendar: View {
    @Bindable var store: StoreOf<AcademicCalendarFeature>
    
    public init(store: StoreOf<AcademicCalendarFeature>) {
        self.store = store
        self.store.send(.selectDate(Date()))
    }
    
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
            
            if !store.eventsForSelectedDate.isEmpty {
                eventInfo(for: store.eventsForSelectedDate)
            } else {
                Spacer()
            }
        }
        .background(Color.Kuring.bg)
        .navigationTitle("학사 일정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear {
            store.send(.onAppearCalendar)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text(store.monthYearString)
                .font(.system(size: 18, weight: .semibold))
            
            Spacer()
            
            HStack(spacing: 26) {
                Button {
                    store.send(.previousMonthTapped)
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.Kuring.primary)
                        .font(.system(size: 20, weight: .medium))
                }
                
                Button {
                    store.send(.nextMonthTapped)
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
            ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
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
            TabView(selection: $store.currentMonthIndex) {
                ForEach(Array(store.months.enumerated()), id: \.offset) { index, month in
                    CalendarMonthView(
                        month: month,
                        selectedDate: $store.selectedDate,
                        events: store.events
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 306)
            .onChangeDebounced(of: store.currentMonthIndex, delay: 0.3) { newIndex in
                store.send(.monthChanged(newIndex))
            }
        }
    }
    
    @ViewBuilder
    private func eventInfo(for events: [AcademicEvent]) -> some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                ForEach(events, id: \.id) { event in
                    VStack(alignment: .leading) {
                        HStack(spacing: 8) {
                            Capsule()
                                .fill((AcademicEventCategory(rawValue: event.category) ?? .etc).color)
                                .frame(width: 4)
                                .frame(maxHeight: .infinity)
                            
                            VStack(spacing: 8) {
                                Text("\(event.summary)")
                                    .foregroundStyle(Color.Kuring.title)
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("\(formatKoreanDateString(event.startTime)) - \(formatKoreanDateString(event.endTime))")
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
    private func formatKoreanDateString(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        guard let date = inputFormatter.date(from: dateString) else {
            return dateString
        }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = "M.dd (E) a h:mm"

        return outputFormatter.string(from: date)
    }
}

#Preview {
    AcademicCalendar(store: .init(initialState: AcademicCalendarFeature.State(), reducer: {
        AcademicCalendarFeature()
    }))
}
