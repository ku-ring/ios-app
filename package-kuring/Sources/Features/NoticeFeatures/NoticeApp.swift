//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import Models
import SwiftData
import Foundation
import LoginFeatures
import DepartmentFeatures
import SubscriptionFeatures
import ComposableArchitecture

@Reducer
public struct NoticeAppFeature {
    @ObservableState
    public struct State: Equatable {
        /// 학사일정 바텀시트
        public var isAcademicSchedulePresented: Bool = false
        
        // MARK: 네비게이션
        /// 루트
        public var noticeList = NoticeListFeature.State()
        /// 스택 네비게이션
        public var path = StackState<Path.State>()
        public var signup = EmailVerificationFeature.State()
        /// 트리 네비게이션 - ``SubscriptionAppFeature``
        @Presents public var changeSubscription: SubscriptionAppFeature.State?
        
        public init(
            noticeList: NoticeListFeature.State = NoticeListFeature.State(),
            path: StackState<Path.State> = StackState<Path.State>(),
            changeSubscription: SubscriptionAppFeature.State? = nil
        ) {
            self.noticeList = noticeList
            self.path = path
            self.changeSubscription = changeSubscription
            
            @Dependency(\.bookmarks) var bookmarks
            do {
                self.noticeList.bookmarkIDs = Set(try bookmarks().map(\.id))
            } catch {
                print("북마크 가져오기를 실패했어요: \(error.localizedDescription)")
            }
        }
        
        mutating func fetchAcademicSchedule() -> AcademicScheduleEntity? {
            @Dependency(\.academicSchedules) var academicDB
            
            do {
                let schedule = try academicDB.fetch(.init())
                return schedule
            } catch {
                print("❌ 캐싱된 학사 일정을 가져오는데 실패 했습니다: \(error)")
                return nil
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
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case onAppear
        /// 루트(``NoticeListFeature``) 액션
        case noticeList(NoticeListFeature.Action)

        /// 스택 네비게이션 액션 (``NoticeAppFeature/Path``)
        case path(StackAction<Path.State, Path.Action>)
        /// 이메일 인증 네비게이션
        case signup(EmailVerificationFeature.Action)

        /// 구독 변경 버튼을 탭한 경우
        case changeSubscriptionButtonTapped

        /// ``SubscriptionAppFeature`` 의 Presentation 액션
        case changeSubscription(PresentationAction<SubscriptionAppFeature.Action>)
        
        case updateBookmarks(_ notice: Notice, _ isBookmarked: Bool)
        
        case toggleAcademicScheduleSheet
        /// 1달치 학사 일정을 가져옵니다
        case fetch1MonthAcademicSchedule
        /// 전체 학사 일정을 가져옵니다
        case fetchEntireAcademicSchedule
        /// 최신 학사 일정만 가져옵니다
        case fetchLatestAcademicSchedule
        case fetchAcademicScheduleResponse(Result<[AcademicEvent], CalendarKuringError>, _ isComplete: Bool)
        
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

    @Dependency(\.bookmarks) var bookmarks
    @Dependency(\.departments) var departments
    @Dependency(\.kuringLink) private var kuringLink
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.noticeList, action: \.noticeList) {
            NoticeListFeature()
        }

        Scope(state: \.signup, action: \.signup) {
            EmailVerificationFeature()
        }
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
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
                    let sevenDaysInSeconds: TimeInterval = 7 * 24 * 60 * 60
                    let rightNow = Date().timeIntervalSince1970
                    let scheduleLastUpdated = schedule.lastUpdated.timeIntervalSince1970
                    
                    // 일주일이 지났다
                    if rightNow - scheduleLastUpdated >= sevenDaysInSeconds {
                        // 일주일치 새로운 학사일정만 가져온다
                        return .concatenate([
                            .send(.fetchLatestAcademicSchedule)
                        ])
                    }
                    // 일주일 안지났으면 아무일도 없음
                    return .none
                }
                return .none
            case .toggleAcademicScheduleSheet:
                state.isAcademicSchedulePresented.toggle()
                return .none
            case .noticeList(.onAppear):
                // 북마크 상태 동기화
                @Dependency(\.bookmarks) var bookmarks
                do {
                    state.noticeList.bookmarkIDs = Set(try bookmarks().map(\.id))
                } catch {
                    print("북마크 가져오기를 실패했어요: \(error.localizedDescription)")
                }
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
                        let result = try await kuringLink.fetchAcademicEvents(nil, nil)
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
                    return .none
                case .failure(let error):
                    print("Error: \(error)")
                    return .none
                }
            case let .path(.element(id: _, action: .detail(.delegate(action)))):
                switch action {
                case let .bookmarkUpdated(notice, isBookmarked):
                    if isBookmarked {
                        state.noticeList.bookmarkIDs.insert(notice.id)
                    } else {
                        state.noticeList.bookmarkIDs.remove(notice.id)
                    }
                    return .send(.updateBookmarks(notice, isBookmarked))
                case .pushToReportContent(let commentId, let content):
                    state.path.append(
                        Path.State.reportComment(
                            NoticeReportCommentFeature.State(
                                commentId: commentId,
                                content: content
                            )
                        )
                    )
                    return .none
                case .pushToLogin:
                    state.path.append(
                        Path.State.login(
                            LoginAppFeature.State()
                        )
                    )
                    return .none
                }
            case let .path(.element(id: _, action: .reportComment(.delegate(.pop)))):
                state.path.removeLast()
                return .none
                  
            case let .updateBookmarks(notice, isBookmarked):
                do {
                    if isBookmarked {
                        try bookmarks.add(notice)
                    } else {
                        try bookmarks.remove(notice.id)
                    }
                } catch {
                    print("북마크 업데이트에 실패했어요: \(error.localizedDescription)")
                }
                return .none

            case let .noticeList(.delegate(delegate)):
                switch delegate {
                case .editDepartment:
                    state.path.removeAll()
                    state.path.append(
                        Path.State.departmentEditor(
                            DepartmentEditorFeature.State()
                        )
                    )
                    return .none
                
                case let .bookmarkUpdated(notice):
                    let isBookmarked = state.noticeList.bookmarkIDs.contains(notice.id)
                    return .send(.updateBookmarks(notice, isBookmarked))
                case .showNoticeDetail(let notice):
                    state.path.append(
                        Path.State.detail(
                            NoticeDetailFeature.State(
                                notice: notice,
                                isBookmarked: state.noticeList.bookmarkIDs.contains(notice.id)
                            )
                        )
                    )
                    return .none
                }
            case .changeSubscription(.presented(.subscriptionView(.subscriptionResponse))):
                /// ``SubscriptionAppFeature`` 액션
                state.changeSubscription = nil
                return .none

            case .changeSubscriptionButtonTapped:
                state.changeSubscription = SubscriptionAppFeature.State()
                return .none
                
            case let .path(.element(id: id, action: .departmentEditor(.delegate(.addedDepartmentsUpdated)))):
                guard case let .departmentEditor(departmentEditorState) = state.path[id: id] else {
                    return .none
                }
                state.noticeList.provider = departmentEditorState.myDepartments.first ?? .emptyDepartment
                return .none
            case let .path(.element(id: id, action: .setPassword(.delegate(.pushToSignupComplete)))):
                state.path.append(
                    Path.State.signupComplete(
                        SignupCompleteFeature.State()
                    )
                )
                return .none
            case let .path(.element(id: id, action: .login(.delegate(.popToRoot)))):
                state.path.removeAll()
                return .none
            case let .path(.element(id: id, action: .login(.delegate(.pushToTerms)))):
                state.path.append(
                    Path.State.signupTerms(
                        LoginAppFeature.State()
                    )
                )
                return .none
            case let .path(.element(id: id, action: .login(.delegate(.pushToFindPassword)))):
                state.path.append(
                    Path.State.findPassword(
                        EmailVerificationFeature.State()
                    )
                )
                return .none
            case let .path(.element(id: id, action: .signupTerms(.delegate(.pushToSignup)))):
                state.path.append(
                    Path.State.signup(
                        EmailVerificationFeature.State()
                    )
                )
                return .none
            case let .path(.element(id: id, action: .changePassword(.delegate(.popToRoot)))):
                state.path.removeAll()
                return .none
            case let .path(.element(id: id, action: .signupComplete(.delegate(.popToRoot)))):
                state.path.removeSubrange(1...)
                return .none
            case let .path(.element(id: _, action: .signup(.delegate(.pushToSignupPassword(email))))):
                state.path.append(
                    Path.State.setPassword(
                        SetPasswordFeature.State(email: email)
                    )
                )
                return .none
            case let .path(.element(id: _, action: .findPassword(.delegate(.pushToChangePassword(email))))):
                state.path.append(
                    Path.State.changePassword(
                        SetPasswordFeature.State(email: email)
                    )
                )
                return .none
            case .path, .noticeList, .changeSubscription, .signup, .binding:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
        .ifLet(\.$changeSubscription, action: \.changeSubscription) {
            SubscriptionAppFeature()
        }
    }

    public init() { }
}
