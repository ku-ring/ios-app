//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import LoginUI
import ClubsUI
import ColorSet
import SearchUI
import DepartmentUI
import SubscriptionUI
import NoticeFeatures
import SearchFeatures
import AcademicCalendarUI
import ComposableArchitecture

public struct NoticeApp: View {
    @Bindable var store: StoreOf<NoticeAppFeature>

    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            NoticeContentView(
                store: self.store.scope(
                    state: \.noticeList,
                    action: \.noticeList
                )
            )
            .background(Color.Kuring.bg)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("appIconLabel", bundle: Bundle.notices)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    // MARK: 검색창 진입

                    NavigationLink(
                        state: NoticeAppFeature.Path.State.search(
                            SearchFeature.State()
                        )
                    ) {
                        Image("magnifyingglass", bundle: Bundle.notices)
                            .foregroundStyle(Color.Kuring.gray400)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    // MARK: 공지보관함 진입
                    NavigationLink(
                        state: NoticeAppFeature.Path.State.bookmark(
                            BookmarkAppFeature.State()
                        )
                    ) {
                        Image("archive", bundle: Bundle.notices)
                            .renderingMode(.template)
                            .foregroundStyle(Color.Kuring.gray400)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    // MARK: 푸시 알림 선택 진입

                    Button {
                        store.send(.pushToNotificationHistory)
                    } label: {
                        Image("bell", bundle: Bundle.notices)
                            .renderingMode(.template)
                            .foregroundStyle(Color.Kuring.gray400)
                    }
                }
            }
            .sheet(isPresented: $store.academicCalendar.isAcademicSchedulePresented) {
                AcademicScheduleSheet(
                    isPresented: $store.academicCalendar.isAcademicSchedulePresented
                )
                .presentationDetents([.height(280)])
                .presentationCornerRadius(20)
                .presentationDragIndicator(.visible)
            }
            .onAppear {
                store.send(.academicCalendar(.onAppearNotice))
            }
        } destination: { store in
            switch store.state {
            case .detail:
                if let store = store.scope(state: \.detail, action: \.detail) {
                    NoticeDetailView(store: store)
                }
            case .search:
                if let store = store.scope(state: \.search, action: \.search) {
                    SearchView(store: store)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle("검색하기")
                }
            case .departmentEditor:
                if let store = store.scope(state: \.departmentEditor, action: \.departmentEditor) {
                    DepartmentEditor(store: store)
                }
            case .reportComment:
                if let store = store.scope(state: \.reportComment, action: \.reportComment) {
                    ReportCommentView(store: store)
                }
            case .login:
                if let store = store.scope(
                    state: \.login,
                    action: \.login
                ) {
                    LoginView(store: store)
                }
            case .findPassword:
                if let store = store.scope(
                    state: \.findPassword,
                    action: \.findPassword
                ) {
                    FindPasswordView(store: store)
                }
            case .changePassword:
                if let store = store.scope(
                    state: \.changePassword,
                    action: \.changePassword
                ) {
                    ChangePasswordView(store: store)
                }
            case .signup:
                if let store = store.scope(
                    state: \.signup,
                    action: \.signup
                ) {
                    SignupView(store: store)
                }
            case .signupTerms:
                if let store = store.scope(
                    state: \.signupTerms,
                    action: \.signupTerms
                ) {
                    LoginTermsAndConditionsView(store: store)
                }
            case .setPassword:
                if let store = store.scope(
                    state: \.setPassword,
                    action: \.setPassword
                ) {
                    SetPasswordView(store: store)
                }
            case .signupComplete:
                if let store = store.scope(
                    state: \.signupComplete,
                    action: \.signupComplete
                ) {
                    SignupCompleteView(store: store)
                }
            case .bookmark:
                if let store = store.scope(
                    state: \.bookmark,
                    action: \.bookmark
                ) {
                    BookmarkApp(store: store)
                }
            case .notificationHistory:
                if let store = store.scope(
                    state: \.notificationHistory,
                    action: \.notificationHistory
                ) {
                    NotificationHistoryView(store: store)
                }
            }
        }
    }

    public init(store: StoreOf<NoticeAppFeature>) {
        self.store = store
    }
}

#Preview {
    NoticeApp(
        store: Store(
            initialState: NoticeAppFeature.State(
                noticeList: NoticeListFeature.State()
            ),
            reducer: { NoticeAppFeature() }
        )
    )
}
