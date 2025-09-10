//
//  AccessToken.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/10/25.
//

import Foundation

/// 엑세스 토큰
public struct AccessToken: Codable {
    public let accessToken: String

    public init(accessToken: String) {
        self.accessToken = accessToken
    }
}

