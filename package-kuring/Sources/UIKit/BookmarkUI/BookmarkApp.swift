//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import LoginUI
import SwiftUI
import NoticeUI
import BookmarkFeatures
import ComposableArchitecture

public struct BookmarkApp: View {
    @Bindable var store: StoreOf<BookmarkAppFeature>
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            BookmarkList(
                store: store.scope(
                    state: \.bookmarkList,
                    action: \.bookmarkList
                )
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("보관함")
        } destination: { store in
            switch store.state {
            case .detail:
                if let store = store.scope(state: \.detail, action: \.detail) {
                    NoticeDetailView(store: store)
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

    public init(store: StoreOf<BookmarkAppFeature>) {
        self.store = store
    }
}

#Preview {
    BookmarkApp(
        store: Store(
            initialState: BookmarkAppFeature.State(
                bookmarkList: BookmarkListFeature.State()
            ),
            reducer: { BookmarkAppFeature() }
        )
    )
}
