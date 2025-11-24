//
//  EmailPassword.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/10/25.
//

import Foundation

/// 서버로 전송하는 사용자 **이메일 + 비밀번호** 값
public struct EmailPassword: Encodable {
    public let email: String
    public let password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
