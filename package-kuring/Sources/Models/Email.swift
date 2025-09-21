//
//  Email.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/10/25.
//

import Foundation

/// 서버로 전송하는 사용자 **이메일** 값
public struct Email: Encodable {
    public let email: String

    public init(email: String) {
        self.email = email
    }
}
