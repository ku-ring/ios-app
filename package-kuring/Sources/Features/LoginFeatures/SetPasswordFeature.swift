//
//  SetPasswordFeature.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/14/25.
//

import Caches
import SwiftUI
import Networks
import ComposableArchitecture

struct PasswordValidator {
    static let passwordRegex = #"^(?=.*[a-z])(?=.*\d)[a-z\d]{6,20}$"#
    
    static func isValidPassword(_ password: String) -> Bool {
        return password.range(of: passwordRegex, options: .regularExpression) != nil
    }
}

@Reducer
public struct SetPasswordFeature {
    @ObservableState
    public struct State: Equatable {
        var email: String
        public var password: String = ""
        public var reEnterPassword: String = ""
        public var showPassword = false
        public var showReEnterPassword = false
        
        public var isValidPassword: Bool {
            PasswordValidator.isValidPassword(password)
        }
        
        public var isValidReEnterPassword: Bool {
            isValidPassword && !reEnterPassword.isEmpty && password == reEnterPassword
        }
        
        public init(email: String) {
            self.email = email
        }
    }

    @Dependency(\.kuringLink) private var kuringLink
    
    public enum Action: BindableAction, Equatable {
        /// 바인딩
        case binding(BindingAction<State>)
        /// 확인 버튼을 눌렀음
        case actionButtonTapped
        /// 비밀번호 변경
        case changePasswordResponse(Result<Bool, LoginKuringError>)
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case pushToSignupComplete
        }
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .actionButtonTapped:
                return .run { [email = state.email, password = state.reEnterPassword] send in
                    do {
                        try await kuringLink.resetPassword(email, password)
                        await send(.changePasswordResponse(.success(true)))
                    } catch {
                        await send(.changePasswordResponse(.failure(.error(error.localizedDescription))))
                    }
                }
            case let .changePasswordResponse(result):
                switch result {
                case .success:
                    return .none
                case let .failure(error):
                    return .none
                }
            default:
                return .none
            }
        }
    }

    public init() { }
}

