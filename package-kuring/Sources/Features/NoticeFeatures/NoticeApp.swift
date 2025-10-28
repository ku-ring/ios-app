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
import AcademicCalendarFeatures

@Reducer
public struct NoticeAppFeature {
    @ObservableState
    public struct State: Equatable {
        // MARK: 네비게이션
        /// 루트
        public var noticeList = NoticeListFeature.State()
        /// 스택 네비게이션
        public var path = StackState<Path.State>()
        public var signup = EmailVerificationFeature.State()
        public var academicCalendar = AcademicCalendarFeature.State()
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
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        /// 루트(``NoticeListFeature``) 액션
        case noticeList(NoticeListFeature.Action)

        /// 스택 네비게이션 액션 (``NoticeAppFeature/Path``)
        case path(StackAction<Path.State, Path.Action>)
        /// 이메일 인증 네비게이션
        case signup(EmailVerificationFeature.Action)
        case academicCalendar(AcademicCalendarFeature.Action)

        /// 구독 변경 버튼을 탭한 경우
        case changeSubscriptionButtonTapped

        /// ``SubscriptionAppFeature`` 의 Presentation 액션
        case changeSubscription(PresentationAction<SubscriptionAppFeature.Action>)
        
        case updateBookmarks(_ notice: Notice, _ isBookmarked: Bool)
    }

    @Dependency(\.bookmarks) var bookmarks
    @Dependency(\.departments) var departments

    public var body: some ReducerOf<Self> {
        Scope(state: \.noticeList, action: \.noticeList) {
            NoticeListFeature()
        }

        Scope(state: \.signup, action: \.signup) {
            EmailVerificationFeature()
        }
        
        Scope(state: \.academicCalendar, action: \.academicCalendar) {
            AcademicCalendarFeature()
        }
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .noticeList(.onAppear):
                // 북마크 상태 동기화
                @Dependency(\.bookmarks) var bookmarks
                do {
                    state.noticeList.bookmarkIDs = Set(try bookmarks().map(\.id))
                } catch {
                    print("북마크 가져오기를 실패했어요: \(error.localizedDescription)")
                }
                return .none
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
            case .path, .noticeList, .changeSubscription, .signup, .binding, .academicCalendar:
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
