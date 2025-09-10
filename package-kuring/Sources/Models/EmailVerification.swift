//
//  EmailVerification.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/10/25.
//

import Foundation

/// 서버로 전송하는  **이메일 + 인증코드** 값
public struct EmailVerification: Codable {
    public let email: String
    public let code: String

    public init(email: String, code: String) {
        self.email = email
        self.code = code
    }
}

