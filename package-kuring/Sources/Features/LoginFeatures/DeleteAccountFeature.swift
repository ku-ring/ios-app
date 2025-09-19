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

        public init() {}
    }

    public enum Action: Equatable {
        case delegate(Delegate)
        /// 회원 탈퇴를 눌렀음
        case onDeleteAccountButtonTapped
        /// 회원탈퇴 api 응답
        case deleteAccountResponse(Result<Bool, LoginKuringError>)
        
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
                return .send(.delegate(.pushToDeleteAccountComplete))
                return .run { send in
                    do {
                        try await kuringLink.withdrawAccount()
                        await send(.deleteAccountResponse(.success(true)))
                    } catch {
                        await send(.deleteAccountResponse(.failure(.error(error.localizedDescription))))
                    }
                }
            case .deleteAccountResponse(let result):
                switch result {
                case .success:
                    return .send(.delegate(.pushToDeleteAccountComplete))
                case .failure(let error):
                    print("Error: \(error)")
                    return .none
                }
            }
        }
    }

    public init() {}
}

