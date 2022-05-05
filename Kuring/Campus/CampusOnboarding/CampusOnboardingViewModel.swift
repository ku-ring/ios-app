//
//  CampusOnboardingViewModel.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import SwiftUI
import KuringCommons
import SendbirdChatSDK

class CampusOnboardingViewModel: ObservableObject {
    @AppStorage(StringSet.Campus.UserDefaults.usernameKey, store: .standard)
    var username: String = ""
    
    @Published private(set) var onDismiss: Bool = false
    
    @Published var unsavedUsername: String = ""
    @Published var activateState: ActivateState = .initial
    
    enum ActivateState: Equatable {
        case initial
        case onEnterNickname
        case connecting
        case connected
        case failed(String)
    }
    
    func start() {
        withAnimation {
            self.activateState = .connecting
        }
        SendbirdChat.connect(userID: KuringCampus.userID) { [weak self] user, error in
            guard let self = self else { return }
            Logger.error(error)
            if let error = error {
                DispatchQueue.main.async {
                    self.activateState = .failed(error.localizedDescription)
                }
                return
            }
            if let user = user {
                if user.nickname == nil {
                    DispatchQueue.main.async {
                        self.activateState = .onEnterNickname
                    }
                } else {
                    DispatchQueue.main.async {
                        self.activateState = .connected
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.activateState = .failed("알 수 없는 에러가 발생했습니다.")
                }
                return
            }
        }
        withAnimation {
            self.activateState = .onEnterNickname
        }
    }
    
    func done() {
        guard !unsavedUsername.isEmpty else { return }
        self.activateState = .connecting
        SendbirdChat.connect(userID: KuringCampus.userID, authToken: nil) { [weak self] user, error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    self.activateState = .failed(error.localizedDescription)
                }
                return
            }
            let params = UserUpdateParams()
            params.nickname = self.unsavedUsername
            SendbirdChat.updateCurrentUserInfo(
                params: params,
                completionHandler:  { error in
                    self.username = self.unsavedUsername
                    DispatchQueue.main.async {
                        self.activateState = .connected
                    }
                }
            )
        }
    }
    
    func dismiss() {
        onDismiss = true
    }
}
