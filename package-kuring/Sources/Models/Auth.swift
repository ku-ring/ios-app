//
//  File.swift
//  
//
//  Created by Geon Woo lee on 4/20/24.
//

import Foundation

/// 계정 정보
public struct Auth: Encodable {
    public let fcmToken: String

    public init(fcmToken: String) {
        self.fcmToken = fcmToken
    }
}
