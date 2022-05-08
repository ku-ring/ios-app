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
        // TODO: 체크 - currentUser의 userID와 동일하면 즉각 리턴 되는가?
        SendbirdChat.connect(userID: KuringCampus.userID, authToken: nil) { [weak self] user, error in
            guard let self = self else { return }
            Logger.error(error)
            if let error = error {
                DispatchQueue.main.async {
                    self.activateState = .failed(error.localizedDescription)
                }
                return
            }
            
            KuringCampus.getUser(named: self.unsavedUsername) { result in
                switch result {
                case .success(let user):
                    if user == nil {
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
                    } else {
                        self.activateState = .failed("이미 존재하는 닉네임입니다.")
                    }
                case .failure(let error):
                    self.activateState = .failed(error.localizedDescription)
                }
            }
        }
    }
    
    func dismiss() {
        onDismiss = true
    }
}
