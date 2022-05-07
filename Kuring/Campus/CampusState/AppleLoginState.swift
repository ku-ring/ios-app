//
//  AppleLoginState.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/08.
//

import Foundation
import KuringSDK
import KuringCommons
import AuthenticationServices

class AppleLoginState: CampusState {
    func configure(_ request: ASAuthorizationAppleIDRequest, context: CampusViewModel) {
        request.requestedScopes = [.fullName, .email]
//        request.nonce = ""
    }
    
    func handleResult(_ result: Result<ASAuthorization, Error>, context: CampusViewModel) {
        switch result {
        case .success(let auth):
            switch auth.credential {
            case let appleIdCredential as ASAuthorizationAppleIDCredential:
                // appleIdCredentials.email
                // appleIdCredentials.user
                if let email = appleIdCredential.email {
                    Kuring.userID = email
                }
                context.changeState(to: ConnectingState())
            default:
                Logger.error("알 수 없는 이유로 로그인 정보에 이메일을 가져올 수 없습니다.")
            }
        case .failure(let error):
            Logger.error(error)
        }
    }
}
