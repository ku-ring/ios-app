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
    static var satellite: Satellite {
        let plistURL = Bundle.module.url(forResource: "KuringLink-Info", withExtension: "plist")!
        let dict = try! NSDictionary(contentsOf: plistURL, error: ())
        let satellite = Satellite(
            host: (dict["API_HOST"] as? String) ?? "",
            scheme: (dict["USING_HTTPS"] as? Bool) ?? true ? .https : .http
        )
        return satellite
    }
    static let appVersion = "" // NEXT_VERSION
    static let iosVersion = {
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        let iosVersion = "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
        return iosVersion
    }()
    
    // MARK: - Notices
    public var fetchNotices: (NoticeCount, NoticeType, Department?, Page) async throws -> [Notice]
    
    public var sendFeedback: (String, FCMToken) async throws -> Bool
    
    // MARK: - Search
    public var searchNotices: (_ keyword: String) async throws -> [Notice]
    
    public var searchStaffs: (_ keyword: String) async throws -> [Staff]
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
        },
        searchNotices: { keyword in
            // TODO: 서버 수정되면 제거하기
            struct SearchedNoticeList: Decodable {
                let noticeList: [SearchedNotice]
            }
            let response: Response<SearchedNoticeList> = try await satellite
                .response(
                    for: Path.searchNotices.path,
                    httpMethod: .get,
                    queryItems: [
                        .init(name: "content", value: keyword)
                    ]
                )
            return response.data.noticeList.compactMap { $0.asNotice }
        },
        searchStaffs: { keyword in
            // TODO: 서버 수정되면 제거하기
            struct StaffList: Decodable {
                let staffList: [Staff]
            }
            let response: Response<StaffList> = try await satellite
                .response(
                    for: Path.searchStaffs.path,
                    httpMethod: .get,
                    queryItems: [
                        .init(name: "content", value: keyword)
                    ]
                )
            return response.data.staffList
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
        },
        searchNotices: { keyword in
            return []
        },
        searchStaffs: { keyword in
            return []
        }
    )
}
