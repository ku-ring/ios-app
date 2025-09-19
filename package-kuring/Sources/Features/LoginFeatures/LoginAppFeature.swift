//
//  LoginAppFeature.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/14/25.
//

import Caches
import Networks
import ComposableArchitecture

@Reducer
public struct LoginAppFeature {
    @Dependency(\.kuringLink) private var kuringLink
    
    @ObservableState
    public struct State: Equatable {
        public var email: String = ""
        public var password: String = ""
        public var isLoading: Bool = false
        public var isPasswordVisible: Bool = false
        @Presents public var alert: AlertState<Action.Alert>?
        
        public init() {}
    }

    public enum Action: BindableAction, Equatable {
        /// 바인딩
        case binding(BindingAction<State>)
        /// 로그인 버튼 눌렀을때
        case loginButtonTapped
        /// 로그인 API 응답
        case loginResponse(Result<Bool, LoginKuringError>)
        /// 알림 관련 액션
        case alert(PresentationAction<Alert>)
        /// 알림
        public enum Alert: Equatable {}
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .loginButtonTapped:
                state.isLoading = true
                return .run { [email = state.email, password = state.password] send in
                    do {
                        try await performLogin(email: email, password: password)
                        await send(.loginResponse(.success((true))))
                    } catch {
                        await send(.loginResponse(.failure(.error(error.localizedDescription))))
                    }
                }
            case let .loginResponse(result):
                state.isLoading = false
                switch result {
                case .success:
                    return .none
                case let .failure(error):
                    state.alert = AlertState {
                        TextState("잘못된 로그인 정보에요.\n다시 입력해주세요.")
                    } actions: {
                        ButtonState(role: .cancel) {
                            TextState("확인")
                        }
                    }
                    return .none
                }
            default:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
    
    private func performLogin(email: String, password: String) async throws {
        try await kuringLink.login(email, password)
    }

    public init() { }
}
