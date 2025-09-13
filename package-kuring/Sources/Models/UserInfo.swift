//
//  UserInfo.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/10/25.
//

import Foundation

/// 사용자 정보 (이메일, 닉네임)
public struct UserInfo: Decodable {
    public let email: String
    public let nickname: String
    
    public init(email: String, nickname: String) {
        self.email = email
        self.nickname = nickname
    }
}
