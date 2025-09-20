//
//  EmailVerificationFeature.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/15/25.
//

import Models
import SwiftUI
import Networks
import ColorSet
import ComposableArchitecture

public enum KumailLink: String {
    case url = "https://kumail.konkuk.ac.kr/"
}

@Reducer
public struct EmailVerificationFeature {
    
    @ObservableState
    public struct State: Equatable {
        /// 이메일 입력값
        public var email: String = ""
        /// 인증번호 입력값
        public var verificationCode: String = ""
        public var timeRemaining: Int = 300 // 5분
        /// 이메일 상태값
        public var emailState: EmailState = .initial
        /// 인증번호 상태값
        public var verificationState: VerificationCodeState = .hidden
        /// 인증번호 인증 가능 상태
        public var canVerifyCode: Bool = false
        
        @Presents public var destination: Destination.State?

        /// 인증번호 입력 필드는 hidden 상태일때 노출되면 안됨
        public var shouldShowVerificationField: Bool {
            switch verificationState {
            case .hidden: return false
            case .active, .invalid: return true
            }
        }
        
        /// 인증번호 버튼은 이메일 입력값과 상태에 따라 상태가 바뀜
        public var verificationButtonState: VerificationButtonState {
            switch emailState {
            case .initial:
                return email.isEmpty ? .disabled : .send
            case .invalid:
                return .send
            case .codeSent:
                return .resend
            }
        }
        
        /// 건국대 이메일인지 확인
        var isEmailValid: Bool {
            email.hasSuffix("@konkuk.ac.kr") && !email.isEmpty
        }
                
        public init() {}
    }
    
    /// 이메일 입력에 대한 state machine
    public enum EmailState: Equatable {
        /// 초기 상태
        case initial
        /// 이메일 형식이 잘못되었음
        case invalid
        /// 인증코드를 보냈음
        case codeSent
    }
    
    /// 인증번호 입력에 대한 state machine
    public enum VerificationCodeState: Equatable {
        /// 초기 상태 (숨겨진 상태)
        case hidden
        /// 타이머가 활성화 됐고 인증번호를 기다리고 있는 상태
        case active(timer: Bool)
        /// 잘못된 인증번호를 입력함
        case invalid
    }
    
    public enum Action: BindableAction, Equatable {
        /// 바인딩
        case binding(BindingAction<State>)
        /// 바텀시트를 위한
        case destination(PresentationAction<Destination.Action>)
        /// 이메일 입력값이 바뀌었음
        case emailChanged
        /// 학교 이메일 바로가기 버튼을 눌렀음
        case showSchoolEmailButtonTapped
        /// 인증번호 버튼을 눌렀음
        case verificationButtonTapped(VerificationType)
        /// 인증번호 API 응답
        case verificationCodeResponse(Result<Bool, LoginKuringError>)
        /// "확인", "다음" 따위의 버튼을 눌렀을때
        case actionButtonPressed(VerificationType)
        /// 인증번호 인증 API 응답
        case verifyCodeResponse(Result<Bool, LoginKuringError>, VerificationType)
        /// 타이머 시작
        case timerTick
        /// 타이머 종료
        case stopTimer
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case pushToSignupPassword(String)
            case pushToChangePassword(String)
        }
    }
    
    public enum VerificationType {
        case signup
        case findPassword
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.kuringLink) private var kuringLink
    private enum CancelID { case timer }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.verificationCode):
                state.canVerifyCode = !state.verificationCode.isEmpty
                return .none
            case .emailChanged:
                // 만약 인증번호를 보낸상태에서 이메일을 수정하면 인증번호 다시 받아야됨
                if state.shouldShowVerificationField {
                    state.emailState = .initial
                    state.verificationState = .hidden
                    state.verificationCode = ""
                    return .cancel(id: CancelID.timer)
                }
                return .none
            case .showSchoolEmailButtonTapped:
                state.destination = .schoolEmail(WebViewFeature.State(url: KumailLink.url.rawValue))
                return .none
            case .verificationButtonTapped(let type):
                guard state.isEmailValid else {
                    state.emailState = .invalid
                    return .none
                }
                return .run { [email = state.email] send in
                    do {
                        if type == .signup {
                            try await kuringLink.sendVerificationCodeOnSignup(email)
                        } else {
                            try await kuringLink.sendVerificationCodeOnPasswordReset(email)
                        }
                        await send(.verificationCodeResponse(.success(true)))
                    } catch {
                        await send(.verificationCodeResponse(.failure(.error(error.localizedDescription))))
                    }
                }
            case let .verificationCodeResponse(result):
                switch result {
                case .success:
                    state.emailState = .codeSent
                    state.verificationState = .active(timer: true)
                    state.timeRemaining = 300
                    return .concatenate([
                        .cancel(id: CancelID.timer),
                        startTimer()
                    ])
                case let .failure(error):
                    state.emailState = .invalid
                    state.verificationState = .hidden
                    return .none
                }
            case .actionButtonPressed(let type):
                return .run { [email = state.email, code = state.verificationCode] send in
                    do {
                        try await kuringLink.verifyVerificationCode(email, code)
                        await send(.verifyCodeResponse(.success(true), type))
                    } catch {
                        await send(.verifyCodeResponse(.failure(.error(error.localizedDescription)), type))
                    }
                }
            case let .verifyCodeResponse(result, type):
                switch result {
                case .success:
                    state.verificationState = .active(timer: false)
                    if type == .signup {
                        return .send(.delegate(.pushToSignupPassword(state.email)))
                    }
                    return .send(.delegate(.pushToChangePassword(state.email)))
                case let .failure(error):
                    state.verificationState = .invalid
                    print(error)
                    return .none
                }
            case .timerTick:
                if state.timeRemaining > 0 {
                    state.timeRemaining -= 1
                    return .none
                } else {
                    if case .active = state.verificationState {
                        state.verificationState = .active(timer: false)
                    }
                    return .cancel(id: CancelID.timer)
                }
            case .stopTimer:
                return .cancel(id: CancelID.timer)
            case .delegate:
                return .none
            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
    
    private func startTimer() -> Effect<Action> {
        return .run { send in
            for await _ in clock.timer(interval: .seconds(1)) {
                await send(.timerTick)
            }
        }
        .cancellable(id: CancelID.timer)
    }
    
    public init() {}
}
