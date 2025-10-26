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
        /// 현재 선택된 월
        public var currentDate = Date()
        /// 현재 선택된 날짜
        public var selectedDate: Date?
        public var months: [Date] = []
        public var currentMonthIndex = 1
        
        /// 학사 일정
        public var events: [AcademicEvent] = []
        
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
            return events.filter { $0.startTime <= dateString && dateString <= $0.endTime }
        }
        
        mutating func fetchAcademicSchedule() -> Bool {
            @Dependency(\.academicSchedules) var academicDB
            
            do {
                let schedule = try academicDB.fetch(.init())
                self.events = (schedule?.events ?? []).map(AcademicEvent.init(from:))
                return schedule?.isComplete ?? false
            } catch {
                print("❌ 캐싱된 학사 일정을 가져오는데 실패 했습니다: \(error)")
                return false
            }
        }
        
        mutating func updateNewSchedule(from apiEvents: [AcademicEvent], isComplete: Bool = false) {
            @Dependency(\.academicSchedules) var academicDB

            let entities = apiEvents.map(AcademicEventEntity.init(from:))
            let schedule = AcademicScheduleEntity(lastUpdated: .now, events: entities)
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

    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case onAppear
        case previousMonthTapped
        case nextMonthTapped
        case monthChanged(Int)
        case selectDate(Date)
        /// 학사 일정 API
        case fetchEntireAcademicSchedule
        case fetchAcademicScheduleResponse(Result<[AcademicEvent], CalendarKuringError>)

        public enum CalendarKuringError: Error, Equatable {
            case error(String)
            
            public static func == (lhs: CalendarKuringError, rhs: CalendarKuringError) -> Bool {
                switch (lhs, rhs) {
                case let (.error(lmsg), .error(rmsg)):
                    return lmsg == rmsg
                }
            }
        }
    }
    
    @Dependency(\.calendar) var calendar
    @Dependency(\.kuringLink) private var kuringLink

    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                if !state.fetchAcademicSchedule() {
                    return .concatenate([
                        initializeMonths(state: &state),
                        .send(.fetchEntireAcademicSchedule)
                    ])
                }
                return initializeMonths(state: &state)
            case .previousMonthTapped:
                state.currentMonthIndex -= 1
                return handleMonthChange(for: state.currentMonthIndex, state: &state)
            case .nextMonthTapped:
                state.currentMonthIndex += 1
                return handleMonthChange(for: state.currentMonthIndex, state: &state)
            case let .monthChanged(index):
                return handleMonthChange(for: index, state: &state)
            case let .selectDate(date):
                state.selectedDate = date
                return .none
            case .fetchEntireAcademicSchedule:
                return .run { send in
                    do {
                        let result = try await kuringLink.fetchAcademicEvents(nil, nil)
                        await send(.fetchAcademicScheduleResponse(.success(result)))
                    } catch {
                        await send(.fetchAcademicScheduleResponse(.failure(.error(error.localizedDescription))))
                    }
                }
            case .fetchAcademicScheduleResponse(let result):
                switch result {
                case .success(let events):
                    state.events = events
                    state.updateNewSchedule(from: events, isComplete: true)
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
            state.months.insert(newPrev, at: 0)
            state.currentMonthIndex = 1
        } else if index == state.months.count - 1 {
            let newNext = calendar.date(byAdding: .month, value: 1, to: state.months.last!)!
            state.months.append(newNext)
        }
        
        state.currentDate = state.months[state.currentMonthIndex]
        return .none
    }
}
