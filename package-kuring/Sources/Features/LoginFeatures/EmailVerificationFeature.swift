//
//  EmailVerificationFeature.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/15/25.
//

import SwiftUI
import ColorSet
import ComposableArchitecture

public enum VerificationType {
    case signup
    case findPassword
}

@Reducer
public struct EmailVerificationFeature {
    
    @ObservableState
    public struct State: Equatable {
        let verificationType: VerificationType
        public var email: String = ""
        public var verificationCode: String = ""
        public var verificationState: VerificationButtonState = .disabled
        public var timeRemaining: Int = 180
        public var isValidEmail: Bool = true
        public var isValidVerificationCode: Bool = true
        public var canProceed: Bool = false
        var isTimerRunning: Bool = false

        public var verificationCodeBorderColor: Color {
            verificationCode.isEmpty ? .clear : (isValidVerificationCode ? Color.Kuring.primary : Color.Kuring.warning)
        }
        
        public init(verificationType: VerificationType) {
            self.verificationType = verificationType
        }
    }
    
    public enum Action: BindableAction, Equatable {
        /// 바인딩
        case binding(BindingAction<State>)
        case verificationButtonTapped
        case timerTick
        case stopTimer
    }
    
    @Dependency(\.continuousClock) var clock
    private enum CancelID { case timer }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .verificationButtonTapped:
                return handleVerificationAction(&state)
                
            case .timerTick:
                if state.timeRemaining > 0 {
                    state.timeRemaining -= 1
                    return .none
                } else {
                    state.isTimerRunning = false
                    return .cancel(id: CancelID.timer)
                }
                
            case .stopTimer:
                state.isTimerRunning = false
                return .cancel(id: CancelID.timer)
            default:
                return .none
            }
        }
    }
    
    private func handleVerificationAction(_ state: inout State) -> Effect<Action> {
        switch state.verificationState {
        case .send:
            state.verificationState = .resend
            state.timeRemaining = 180
            state.isTimerRunning = true
            return startTimer()
        case .resend:
            state.timeRemaining = 180
            return startTimer()
        case .disabled:
            return .none
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
