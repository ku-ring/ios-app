//
//  AcademicScheduleSheet.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/23/25.
//


import Caches
import Models
import SwiftUI
import ColorSet
import SwiftData
import Dependencies

/// 주요 학사 일정을 한번에 보여주는 바텀시트 뷰
/// 높이는 **280**으로 사용
/// ```swift
///    .sheet(isPresented: $isPresented) {
///        AcademicScheduleSheet(
///            schedules: schedules,
///            isPresented: $isPresented
///        )
///        .presentationDetents([.height(280)])
///        .presentationCornerRadius(20)
///        .presentationDragIndicator(.visible)
///    }
/// ```
///  - Parameters:
///    - schedules: 보여줄 학사 일정들
///    - isPresented: 바텀시트 노출 여부
public struct AcademicScheduleSheet: View {
    @Dependency(\.activeTab) var activeTab
    
    let events: [AcademicEvent]
    @State var currentPage: Int = 0
    @Binding var isPresented: Bool
    
    public init(
        isPresented: Binding<Bool>
    ) {
        @Dependency(\.academicSchedules) var academicDB
        let cachedEvents = ((try? academicDB.fetch(.init())?.events ?? []) ?? []).map(AcademicEvent.init(from:))
        
        self.events = cachedEvents.filter { $0.overlapsWithCurrentWeek() }
        self._isPresented = isPresented
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Text("이번 주 예정된 학사일정을 확인해보아요")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color.Kuring.title)
                .padding(.top, 24)

            TabView(selection: $currentPage) {
                ForEach(events.indices, id: \.self) { index in
                    ScheduleCard(event: events[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.top, 16)
            
            HStack(spacing: 8) {
                ForEach(events.indices, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.Kuring.primary : Color.Kuring.primary.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut(duration: 0.3), value: currentPage)
                }
            }
            .padding(.top, 24)
            
            Button(action: {
                isPresented = false
                Task {
                    try? await Task.sleep(for: .milliseconds(200))
                    activeTab.store.value = .calendar
                }
            }) {
                Text("학사일정 전체 확인하기 >")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.Kuring.bg)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(
                        Capsule()
                            .fill(Color.Kuring.primary)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .padding(.top, 24)
        }
        .background(Color.Kuring.bg)
    }
}

private extension AcademicEvent {
    /// 해당 학사일정과 이번주와 일정이 겹치는지
    func overlapsWithCurrentWeek() -> Bool {
        let calendar = Calendar.current
        let today = Date()
        
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) else {
            return false
        }
        
        let weekStart = weekInterval.start
        let weekEnd = weekInterval.end
        
        guard let eventStart = toDate(startTime),
              let eventEnd = toDate(endTime) else {
            return false
        }
        
        return eventStart < weekEnd && eventEnd >= weekStart
    }
    
    func toDate(_ date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: date)
    }
}

/// 학사 일정 바텀시트에 사용되는 하나의 학사 일정 카드
/// ```swift
///    ScheduleCard(schedule: schedules[index])
/// ```
///  - Parameters:
///    - schedule: 보여줄 학사 일정
struct ScheduleCard: View {
    let event: AcademicEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.summary)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color.Kuring.title)
            
            Text("\(formatKoreanDateString(event.startTime)) - \(formatKoreanDateString(event.endTime))")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color.Kuring.caption1)
        }
        .frame(maxHeight: 60)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.Kuring.primarySelected)
        )
        .padding(.horizontal, 20)
    }
}

extension ScheduleCard {
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
    @Previewable @State var currentPage = 0
    @Previewable @State var isPresented = false
    
    let events = [
        AcademicEvent(
            id: 0,
            eventUid: "0000",
            summary: "테스트 학사일정",
            description: "일정이에유",
            category: "ETC",
            startTime: "2025-10-25T00:00:00",
            endTime: "2025-10-28T00:00:00"
        ),
        AcademicEvent(
            id: 1,
            eventUid: "0001",
            summary: "또다른 테스트 학사일정",
            description: "이정이에유",
            category: "ETC",
            startTime: "2025-10-25T00:00:00",
            endTime: "2025-10-28T00:00:00"
        ),
    ]
    
    VStack {
        Button("Show Schedule") {
            isPresented = true
        }
        .padding()
    }
    .sheet(isPresented: $isPresented) {
        AcademicScheduleSheet(isPresented: $isPresented)
            .presentationDetents([.height(280)])
            .presentationCornerRadius(20)
            .presentationDragIndicator(.visible)
    }
}
