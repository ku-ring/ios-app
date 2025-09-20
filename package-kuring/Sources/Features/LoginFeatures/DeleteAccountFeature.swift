//
//  DeleteAccountFeature.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/18/25.
//

import Networks
import Foundation
import ComposableArchitecture

@Reducer
public struct DeleteAccountFeature {
    @ObservableState
    public struct State: Equatable {
        @Presents public var alert: AlertState<Action.Alert>?
        
        public init() {}
    }

    public enum Action: Equatable {
        case delegate(Delegate)
        /// 알림 관련 액션
        case alert(PresentationAction<Alert>)
        /// 회원 탈퇴를 눌렀음
        case onDeleteAccountButtonTapped
        /// 회원탈퇴 api 응답
        case deleteAccountResponse(Result<Bool, LoginKuringError>)
        
        /// 알림
        public enum Alert: Equatable {
            /// 회원 탈퇴진행
            case deleteAccount
        }
        
        public enum Delegate: Equatable {
            /// 회원 탈퇴 완료 화면으로 이동
            case pushToDeleteAccountComplete
            /// 루트로 pop~
            case popToRoot
        }
    }
    
    @Dependency(\.kuringLink) private var kuringLink

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none
            case .onDeleteAccountButtonTapped:
                state.alert = AlertState {
                    TextState("정말 쿠링을 탈퇴하시겠어요?\n해당 단계 이후 계정 복구가 불가해요.")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("취소")
                    }
                    
                    ButtonState(
                        role: .destructive,
                        action: .deleteAccount
                    ) {
                        TextState("탈퇴하기")
                    }
                }
                return .none
            case let .alert(.presented(alertAction)):
                switch alertAction {
                case .deleteAccount:
                    return .run { send in
                        do {
                            try await kuringLink.withdrawAccount()
                            await send(.deleteAccountResponse(.success(true)))
                        } catch {
                            await send(.deleteAccountResponse(.failure(.error(error.localizedDescription))))
                        }
                    }
                }
            case .deleteAccountResponse(let result):
                switch result {
                case .success:
                    state.alert = nil
                    return .send(.delegate(.pushToDeleteAccountComplete))
                case .failure(let error):
                    print("Error: \(error)")
                    return .none
                }
            default:
                return .none
            }
        }
    }

    public init() {}
}

