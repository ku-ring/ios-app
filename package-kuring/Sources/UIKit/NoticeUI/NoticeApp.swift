//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import LoginUI
import SwiftUI
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
                    // MARK: 푸시 알림 선택 진입

                    Button {
                        store.send(.changeSubscriptionButtonTapped)
                    } label: {
                        Image("bell", bundle: Bundle.notices)
                            .foregroundStyle(Color.Kuring.gray400)
                    }
                }
            }
            .sheet(
                item: $store.scope(
                    state: \.changeSubscription,
                    action: \.changeSubscription
                )
            ) { store in
                SubscriptionApp(store: store)
            }
            .sheet(isPresented: $store.isAcademicSchedulePresented) {
                AcademicScheduleSheet(
                    isPresented: $store.isAcademicSchedulePresented
                )
                .presentationDetents([.height(280)])
                .presentationCornerRadius(20)
                .presentationDragIndicator(.visible)
            }
            .onAppear {
                store.send(.onAppear)
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
