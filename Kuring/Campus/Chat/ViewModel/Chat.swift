//
//  Chat.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import Foundation
import SendbirdChatSDK

class Chat: NSObject {
    var currentChannel: OpenChannel?
    
    override init() {
        super.init()
        
        // MARK: 1. Init Chat with Sendbird's App ID
        let params = InitParams(applicationID: KuringCampus.appID)
        SendbirdChat.initialize(params: params)
    }
    
    func connect(nickname: String, resultHandler: @escaping (Result<User, Error>) -> Void) {
        SendbirdChat.connect(userID: KuringCampus.userID) { [nickname] user, error in
            guard let user = user else {
                // 커넥션 에러
                resultHandler(.failure(error!))
                return
            }
            guard user.nickname != nickname else {
                // 닉네임 설정 필요 없이 바로 리턴
                resultHandler(.success(user))
                return
            }
            let params = UserUpdateParams()
                .that { $0.nickname = nickname }
            let completionHandler: SBErrorHandler = { [user] error in
                if let error = error {
                    // 닉네임 업데이트 에러: 활성화 실패
                    resultHandler(.failure(error))
                } else {
                    // 닉네임 업데이트 성공
                    resultHandler(.success(user))
                }
            }
            SendbirdChat.updateCurrentUserInfo(params: params, completionHandler: completionHandler)
        }
    }
    
    func fetchChannel(resultHandler: ((Result<OpenChannel?, Never>) -> Void)? = nil) {
        OpenChannel.getChannel(url: StringSet.Campus.channelID) { channel, error in
            self.currentChannel = channel
            resultHandler?(.success(channel))
        }
    }
}
