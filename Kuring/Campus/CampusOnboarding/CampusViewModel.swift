//
//  CampusViewModel.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/07.
//

import Foundation
import KuringSDK
import KuringCommons
import SendbirdChatSDK
import AuthenticationServices

class CampusViewModel: ObservableObject {
    @Published private(set) var onDismiss: Bool = false
    @Published var pendingUsername: String = ""
    
    @Published var currentState: CampusState = InitialState() {
        willSet { currentState.finish(context: self) }
        didSet { currentState.start(context: self) }
    }
    
    init() {    
        self.currentState.start(context: self)
        Kuring.userID = KuringCampus.userID
    }
    
    func changeState(to newState: CampusState) {
        self.currentState = newState
    }
    
    func dismiss() {
        onDismiss = true
    }
    
    // MARK: - actions
    func signInWithKakao() {
        guard let currentState = self.currentState as? LoginState else { return }
        currentState.loginWithKakao(context: self)
    }
    
    func signInWithApple() {
        guard let currentState = self.currentState as? LoginState else { return }
        currentState.loginWithApple(context: self)
    }
    
    func configure(_ request: ASAuthorizationAppleIDRequest) {
        guard let currentState = self.currentState as? AppleLoginState else { return }
        currentState.configure(request, context: self)
    }
    
    func handleResult(_ result: Result<ASAuthorization, Error>) {
        guard let currentState = self.currentState as? AppleLoginState else { return }
        currentState.handleResult(result, context: self)
    }
    
    func setupUsername() {
        guard let currentState = self.currentState as? UsernameRequestState else { return }
        currentState.updateUsername(to: pendingUsername, context: self)
    }
    
    func startChat() {
        guard let currentState = self.currentState as? ConnectedState else { return }
        currentState.startChat(context: self)
    }
}
