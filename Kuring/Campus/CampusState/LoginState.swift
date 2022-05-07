//
//  LoginState.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/08.
//

import Foundation

class LoginState: CampusState {
    func loginWithKakao(context: CampusViewModel) {
        context.changeState(to: KakaoLoginState())
    }
    
    func loginWithApple(context: CampusViewModel) {
        context.changeState(to: AppleLoginState())
    }
}
