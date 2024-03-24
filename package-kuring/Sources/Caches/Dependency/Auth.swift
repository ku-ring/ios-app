//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import Foundation
import Dependencies

/// 쿠링맵 지원하면서 로그인 케이스가 다양해질 것을 고려하여 대응
public enum AuthTokenType: Codable {
    case fcm
}

public struct Auth {
    /// 토큰 정보
    public var getToken: (_ type: AuthTokenType) -> String?
    /// 토큰 정보 등록
    public var registerToken: (_ type: AuthTokenType, _ value: String) -> Void
    
    @UserDefault(key: StringSet.fcmToken, defaultValue: [:])
    static var tokenDictionary: [AuthTokenType: String]
}

extension Auth {
    public static var `default` = Auth (
        getToken: { type in
            switch tokenType {
            case .fcm:
                return tokenDictionary[.fcm]
            }
            
        }, registerToken: { type, value in
            switch type {
            case .fcm:
                tokenDictionary[.fcm] = value
            }
        }
    )

}
