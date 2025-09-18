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
        case popToRoot
        case delegate(Delegate)
        case onDeleteAccountButtonTapped
        case deleteAccountResponse(Result<Bool, LoginKuringError>)
        
        public enum Delegate: Equatable {
            case pushToDeleteAccountComplete
            case popToRoot
        }
    }
    
    @Dependency(\.kuringLink) private var kuringLink

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .popToRoot:
                return .send(.delegate(.popToRoot))
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

