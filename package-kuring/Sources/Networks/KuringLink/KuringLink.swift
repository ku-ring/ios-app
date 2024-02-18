//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import Satellite
import Foundation

// TODO: 네이밍 통일: NoticeType vs NoticeProvider vs UnivNoticeProvider
public typealias NoticeCount = Int
public typealias NoticeType = String
public typealias Department = String
public typealias Page = Int

public typealias FCMToken = String

public typealias NoticeTypeName = String
public typealias DepartmentHostPrefix = String

public struct KuringLink {
    static var satellite: Satellite {
        let plistURL = Bundle.module.url(forResource: "KuringLink-Info", withExtension: "plist")!
        let dict = try! NSDictionary(contentsOf: plistURL, error: ())
        let satellite = Satellite(
            host: (dict["API_HOST"] as? String) ?? "",
            scheme: (dict["USING_HTTPS"] as? Bool) ?? true ? .https : .http
        )
        //        satellite._startGPS()
        return satellite
    }

    // TODO: 세팅 방식 개선
    public static let appVersion = "2.0.0" // NEXT_VERSION
    
    static let iosVersion = {
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        let iosVersion = "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
        return iosVersion
    }()

    @AppStorage("com.kuring.sdk.token.fcm")
    static var fcmToken: String = ""
    
    static var testableFCMToken: String = "cZSHjO4_bUjirvsrxWzig5:APA91bHPojABL5oEXi5AcjJ8v4Vcp3KpJfFUD_3b-HhfV8m23_R6czJa3PwqcVqBZSHBb2t7Z3odUeD0cFKaMSkMmrGxTqyjJPfEZVfTPvmewV-xiMTWbrk-QKuc4Nrxd_BhEArO7Svo"

    // MARK: - Notices
    /// 특정 카테고리에 대한 공지를 가져옵니다.
    public var fetchNotices: (NoticeCount, NoticeType, Department?, Page) async throws -> [Notice]
    
    // MARK: - Feedback
    /// 피드백 전송
    public var sendFeedback: (String) async throws -> Bool

    // MARK: - Search
    /// 공지 검색하기
    public var searchNotices: (_ keyword: String) async throws -> [Notice]
    /// 교직원 검색하기
    public var searchStaffs: (_ keyword: String) async throws -> [Staff]

    // MARK: - Subscriptions

    /// 대학 공지 카테고리를 구독하기
    public var subscribeUnivNotices: ([NoticeTypeName]) async throws -> Bool
    /// 학과 공지 카테고리를 구독하기
    public var subscribeDepartments: ([DepartmentHostPrefix]) async throws -> Bool
    /// 구독한 대학 공지 카테고리 리스트
    public var getSubscribedUnivNotices: () async throws -> [NoticeProvider]
    /// 구독한 학과 공지 카테고리 리스트
    public var getSubscribedDepartments: () async throws -> [NoticeProvider]
    /// 모든 대학 공지 카테고리 가져오기
    public var getAllUnivNoticeType: () async throws -> [NoticeProvider]
    /// 모든 학과 공지 카테고리 가져오기
    public var getAllDepartments: () async throws -> [NoticeProvider]
}
