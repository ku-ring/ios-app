//
//  KuringLink.swift
//
//
//  Created by Jaesung Lee on 2023/09/13.
//

import Model
import Satellite
import Foundation

public typealias NoticeCount = Int
public typealias NoticeType = String
public typealias Department = String
public typealias Page = Int

public typealias FCMToken = String

public struct KuringLink {
    static let satellite = Satellite(host: <#API_HOST#>, scheme: <#.https#>)
    static let appVersion = "" // NEXT_VERSION
    static let iosVersion = {
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        let iosVersion = "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
        return iosVersion
    }()
    
    // MARK: - Notices
    public var fetchNotices: (NoticeCount, NoticeType, Department?, Page) async throws -> [Notice]
    
    public var sendFeedback: (String, FCMToken) async throws -> Bool
}


extension KuringLink {
    public static let liveValue: KuringLink = KuringLink(
        fetchNotices: { count, type, department, page in
            let response: Response<[Notice]> = try await satellite
                .response(
                    for: Path.getNotices.path,
                    httpMethod: .get,
                    queryItems: [
                        .init(name: "type", value: type),
                        .init(name: "department", value: department),
                        .init(name: "page", value: String(page)),
                        .init(name: "size", value: String(count))
                    ]
                )
            return response.data
        },
        sendFeedback: { text, fcmToken in
            let response: EmptyResponse = try await satellite
                .response(
                    for: Path.sendFeedback.path,
                    httpMethod: .post,
                    httpHeaders: [
                        "Content-Type": "application/json",
                        "User-Token": fcmToken,
                        "User-Agent": "Kuring/\(appVersion) iOS/\(iosVersion)"
                    ],
                    httpBody: Feedback(content: text)
                )
            let isSucceed = (200..<300) ~= response.code
            return isSucceed
        }
    )
}


extension KuringLink {
    public static let testValue: KuringLink = KuringLink(
        fetchNotices: { count, type, department, page in
            return [Notice.random]
        },
        sendFeedback: { text, fcmToken in
            return true
        }
    )
}
