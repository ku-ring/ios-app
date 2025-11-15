//
//  AcademicCalendarFeature.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/23/25.
//

import Caches
import Models
import Networks
import Foundation
import Dependencies
import ComposableArchitecture

@Reducer
public struct AcademicCalendarFeature {
    @ObservableState
    public struct State: Equatable {
        /// 학사일정 바텀시트
        public var isAcademicSchedulePresented: Bool = false
        /// 현재 선택된 월
        public var currentDate = Date()
        /// 현재 선택된 날짜
        public var selectedDate: Date?
        public var months: [Date] = []
        public var currentMonthIndex = 1
        
        /// 학사 일정
        public var events: [AcademicEvent] = []
        
        /// 이동하려는 월이 오늘 - 3년 전이라면 false
        var canShowPreviousMonth: Bool {
            let prevMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)
            return !Date().isThreeYearsOrMoreSince(prevMonth ?? Date())
        }
        
        /// 이동하려는 월이 오늘 + 3년 후라면 false
        var canShowNextMonth: Bool {
            let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
            return !Date().isThreeYearsOrMoreBefore(nextMonth ?? Date())
        }
        
        public var monthYearString: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "M월 yyyy"
            return formatter.string(from: currentDate)
        }
        
        public var eventsForSelectedDate: [AcademicEvent] {
            let calendar = Calendar.current
            guard let selectedDate,
                  calendar.isDate(selectedDate, equalTo: currentDate, toGranularity: .month)
            else {
                return []
            }
            
            let midnight = calendar.startOfDay(for: selectedDate)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let dateString = formatter.string(from: midnight)
            let target = dateString.prefix(10)
            return events.filter {
                let startDay = $0.startTime.prefix(10)
                let endDay = $0.endTime.prefix(10)

                return startDay <= target && target <= endDay
            }
        }
        
        mutating func fetchAcademicSchedule() -> AcademicScheduleEntity? {
            @Dependency(\.academicSchedules) var academicDB
            
            do {
                let schedule = try academicDB.fetch(.init())
                self.events = (schedule?.events ?? []).map(AcademicEvent.init(from:))
                return schedule
            } catch {
                print("❌ 캐싱된 학사 일정을 가져오는데 실패 했습니다: \(error)")
                return nil
            }
        }
        
        mutating func updateNewSchedule(from apiEvents: [AcademicEvent], isComplete: Bool = false) {
            @Dependency(\.academicSchedules) var academicDB

            let entities = apiEvents.map(AcademicEventEntity.init(from:))
            let threeYearsAfter = Calendar.current.date(byAdding: .year, value: 3, to: .now)

            let schedule = AcademicScheduleEntity(lastUpdated: threeYearsAfter ?? Date(), events: entities)
            schedule.isComplete = isComplete
            
            do {
                try academicDB.add(schedule)
                print("✅ \(entities.count)개의 학사 일정 추가를 성공했습니다")
            } catch {
                print("❌ 힉사일정을 SwiftData에 추가하는데 실패했습니다: \(error)")
            }
        }
        
        public init() {}
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        /// 공지사항 탭 onAppear
        case onAppearNotice
        /// 학사일정 탭 onAppear
        case onAppearCalendar
        case previousMonthTapped
        case nextMonthTapped
        case monthChanged(Int)
        case selectDate(Date)
        /// 학사 일정 API
        case toggleAcademicScheduleSheet
        /// 1달치 학사 일정을 가져옵니다
        case fetch1MonthAcademicSchedule
        /// 전체 학사 일정을 가져옵니다
        case fetchEntireAcademicSchedule
        /// 최신 학사 일정만 가져옵니다
        case fetchLatestAcademicSchedule
        case fetchAcademicScheduleResponse(Result<[AcademicEvent], CalendarKuringError>, _ isComplete: Bool)
    }
    
    @Dependency(\.calendar) var calendar
    @Dependency(\.kuringLink) private var kuringLink
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .toggleAcademicScheduleSheet:
                state.isAcademicSchedulePresented.toggle()
                return .none
            case .onAppearNotice:
                // 캐싱된 학사일정이 없을시,
                // 1달치 일정을 먼저 가져오고 바텀시트를 노출한 후, 모든 일정을 가져온다
                guard let schedule = state.fetchAcademicSchedule() else {
                    return .concatenate([
                        .send(.fetch1MonthAcademicSchedule),
                        .send(.fetchEntireAcademicSchedule)
                    ])
                }
                
                // 캐싱된 학사일정이 있다
                if !schedule.events.isEmpty {
                    let cachedDate = Calendar.current.date(byAdding: .year, value: -3, to: schedule.lastUpdated) ?? .now
                    
                    // 마지막으로 캐싱한 날짜와 현재와 주(week)가 다르다
                    if cachedDate.isInDifferentWeek(from: .now) {
                        // 새로운 학사일정만 가져온다
                        return .concatenate([
                            .send(.fetchLatestAcademicSchedule)
                        ])
                    }
                    // 일주일 안지났으면 아무일도 없음
                    return .none
                }
                return .none
            case .onAppearCalendar:
                guard state.months.isEmpty else { return .none }
                let actions: Effect<Action> = .concatenate([
                    initializeMonths(state: &state),
                    .send(.fetchEntireAcademicSchedule)
                ])
                // 만약 캐싱된 학사일정이 없다면
                guard let schedule = state.fetchAcademicSchedule() else {
                    return actions
                }
                state.events = schedule.events.map(AcademicEvent.init(from:))
                // 만약 캐싱된 학사일정은 있지만 최신이 아니라면
                if !schedule.isComplete {
                    return actions
                }
                return initializeMonths(state: &state)
            case .previousMonthTapped:
                state.currentMonthIndex = state.currentMonthIndex > 0 ? state.currentMonthIndex - 1 : 0
                return handleMonthChange(for: state.currentMonthIndex, state: &state)
            case .nextMonthTapped:
                state.currentMonthIndex = state.currentMonthIndex >= state.months.count - 1 ? state.months.count - 1 : state.currentMonthIndex + 1
                return handleMonthChange(for: state.currentMonthIndex, state: &state)
            case let .monthChanged(index):
                return handleMonthChange(for: index, state: &state)
            case let .selectDate(date):
                state.selectedDate = date
                return .none
            case .fetch1MonthAcademicSchedule:
                return .run { send in
                    do {
                        let result = try await kuringLink.fetchAcademicEvents(
                            dateFormatter.string(from: Date().startDateOfMonth),
                            dateFormatter.string(from: Date().endDateOfMonth)
                        )
                        await send(.fetchAcademicScheduleResponse(.success(result), false))
                        await send(.toggleAcademicScheduleSheet)
                    } catch {
                        await send(.fetchAcademicScheduleResponse(.failure(.error(error.localizedDescription)), false))
                    }
                }
            case .fetchEntireAcademicSchedule:
                return .run { send in
                    do {
                        let range: (start: String, end: String) = (
                            dateFormatter.string(
                                from: Calendar.current.date(byAdding: .year, value: -3, to: Date()) ?? Date()
                            ),
                            dateFormatter.string(
                                from: Calendar.current.date(byAdding: .year, value: 3, to: Date()) ?? Date()
                            )
                        )
                        let result = try await kuringLink.fetchAcademicEvents(range.start, range.end)
                        await send(.fetchAcademicScheduleResponse(.success(result), true))
                    } catch {
                        await send(.fetchAcademicScheduleResponse(.failure(.error(error.localizedDescription)), false))
                    }
                }
            case .fetchLatestAcademicSchedule:
                guard let schedule = state.fetchAcademicSchedule() else {
                    return .none
                }
                
                return .run { send in
                    do {
                        let result = try await kuringLink.fetchAcademicEvents(dateFormatter.string(from: schedule.lastUpdated), nil)
                        await send(.fetchAcademicScheduleResponse(.success(result), true))
                        await send(.toggleAcademicScheduleSheet)
                    } catch {
                        await send(.fetchAcademicScheduleResponse(.failure(.error(error.localizedDescription)), false))
                    }
                }
            case .fetchAcademicScheduleResponse(let result, let isComplete):
                switch result {
                case .success(let events):
                    state.updateNewSchedule(from: events, isComplete: isComplete)
                    state.events = events
                    return .none
                case .failure(let error):
                    print("Error: \(error)")
                    return .none
                }
            case .binding:
                return .none
            }
        }
    }

    public init() { }
}

extension AcademicCalendarFeature {
    // 기본적으로 3달만 보유
    private func initializeMonths(state: inout State) -> Effect<Action> {
        let prevMonth = calendar.date(byAdding: .month, value: -1, to: state.currentDate) ?? state.currentDate
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: state.currentDate) ?? state.currentDate
        state.months = [prevMonth, state.currentDate, nextMonth]
        return .none
    }

    // 월이 바뀌는 상황에 사용
    private func handleMonthChange(for index: Int, state: inout State) -> Effect<Action> {
        guard !state.months.isEmpty else { return .none }
        
        if index == 0 {
            let newPrev = calendar.date(byAdding: .month, value: -1, to: state.months.first!)!
            let prevMonth = Calendar.current.date(byAdding: .month, value: -1, to: state.currentDate) ?? Date()
            
            if !Date().isThreeYearsOrMoreSince(prevMonth) {
                state.months.insert(newPrev, at: 0)
                state.currentMonthIndex = 1
            } else {
                state.currentMonthIndex = 0
            }
        } else if index == state.months.count - 1 {
            let newNext = calendar.date(byAdding: .month, value: 1, to: state.months.last!)!
            
            if !Date().isThreeYearsOrMoreBefore(newNext) {
                state.months.append(newNext)
            }
        }
        
        state.currentDate = state.months[state.currentMonthIndex]
        return .none
    }
}
