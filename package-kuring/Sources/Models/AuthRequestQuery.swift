//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

/// 계정 정보
public struct AuthRequest: Encodable {
    public let token: String

    public init(fcmToken: String) {
        self.token = fcmToken
    }
}
