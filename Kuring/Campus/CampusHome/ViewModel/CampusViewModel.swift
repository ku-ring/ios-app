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
    @Published var pendingUsername: String = "" {
        didSet { errorMessage = "" }
    }
    @Published var errorMessage: String = ""
    
    @Published var currentState: CampusState = InitialState() {
        willSet { currentState.finish(context: self) }
        didSet { currentState.start(context: self) }
    }
    @Published var isConformsToRegex: Bool = true
    @Published var onError: Bool = false
    @Published var onChat: Bool = false {
        didSet {
            if !onChat { endChat() }
        }
    }
    
    init() {    
        self.currentState.start(context: self)
    }
    
    func changeState(to newState: CampusState) {
        self.currentState = newState
    }
    
    func dismiss() {
        onDismiss = true
    }
    
    // MARK: - actions
    func signInWithGoogle() {
        guard let currentState = self.currentState as? LoginState else { return }
        currentState.loginWithGoogle(context: self)
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
        isConformsToRegex = pendingUsername.conformsToUsernameProtocol && pendingUsername.count > 5 && pendingUsername.count <= 15
        guard isConformsToRegex else { return }
        guard let currentState = self.currentState as? UsernameRequestState else { return }
        currentState.checkAvailablity(username: pendingUsername, context: self)
    }
    
    func didFailToSetupUsername(with message: String) {
        errorMessage = message
        Logger.error(message)
    }
    
    func updateUsername() {
        guard let currentState = self.currentState as? UsernameRequestState else { return }
        currentState.updateUsername(to: pendingUsername, context: self)
    }
    
    func startChat() {
        guard let currentState = self.currentState as? ConnectedState else { return }
        currentState.startChat(context: self)
    }
    
    func endChat() {
        guard let currentState = self.currentState as? ChatStartedState else { return }
        currentState.endChat(context: self)
    }
    
    func restart() {
        onError = false
        currentState.restart(context: self)
    }
}
