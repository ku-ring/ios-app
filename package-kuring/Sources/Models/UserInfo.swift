//
//  UserInfo.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/10/25.
//

import Foundation

struct UserInfo: Codable {
    public let email: String
    public let nickname: String
    
    public init(email: String, nickname: String) {
        self.email = email
        self.nickname = nickname
    }
}
