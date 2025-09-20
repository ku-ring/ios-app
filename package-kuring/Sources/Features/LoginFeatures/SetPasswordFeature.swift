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
        case actionButtonTapped(SetPasswordType)
        /// 비밀번호 변경/회원가입 응답
        case response(Result<Bool, LoginKuringError>, SetPasswordType)
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case pushToSignupComplete
            case popToRoot
        }
        
        public enum SetPasswordType {
            case signup
            case changePassword
        }
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .actionButtonTapped(let type):
                return .run { [email = state.email, password = state.reEnterPassword] send in
                    do {
                        if type == .signup {
                            try await kuringLink.signUp(email, password)
                        } else {
                            try await kuringLink.resetPassword(email, password)
                        }
                        await send(.response(.success(true), type))
                    } catch {
                        await send(.response(.failure(.error(error.localizedDescription)), type))
                    }
                }
            case let .response(result, type):
                switch result {
                case .success:
                    if type == .signup {
                        return .send(.delegate(.pushToSignupComplete))
                    }
                    return .send(.delegate(.popToRoot))
                case let .failure(error):
                    print(error)
                    return .none
                }
            default:
                return .none
            }
        }
    }

    public init() { }
}

