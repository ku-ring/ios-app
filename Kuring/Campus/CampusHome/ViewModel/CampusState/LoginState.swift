//
//  LoginState.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/08.
//

import Foundation

class LoginState: CampusState {
    func loginWithGoogle(context: CampusViewModel) {
        context.changeState(to: GoogleLoginState())
    }
    
    func loginWithApple(context: CampusViewModel) {
        context.changeState(to: AppleLoginState())
    }
}
