//
//  LoginAppFeature.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/14/25.
//

import Caches
import Foundation
import ComposableArchitecture

@Reducer
public struct LoginAppFeature {
    @ObservableState
    public struct State: Equatable {
        public var email: String = ""
        public var password: String = ""
        public var isLoading: Bool = false
        public var showError: Bool = false
        public var isPasswordVisible: Bool = false
        
        public init() {}
    }

    public enum Action: BindableAction, Equatable {
        /// 바인딩
        case binding(BindingAction<State>)
        case loginButtonTapped
        case loginResponse(Result<Bool, LoginError>)
        
        public enum LoginError: Error, Equatable {
            case error(String)
            
            public static func == (lhs: LoginError, rhs: LoginError) -> Bool {
                switch (lhs, rhs) {
                case let (.error(lmsg), .error(rmsg)):
                    return lmsg == rmsg
                }
            }
        }
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
                    } catch let error as LoginAppFeature.Action.LoginError {
                        await send(.loginResponse(.failure(error)))
                    }
                }
            case let .loginResponse(result):
                state.isLoading = false
                switch result {
                case .success:
                    return .none
                case let .failure(error):
                    state.showError = true
                    return .none
                }
            default:
                return .none
            }
        }
    }
    
    private func performLogin(email: String, password: String) async throws {
        throw LoginAppFeature.Action.LoginError.error("asda")
    }

    public init() { }
}
